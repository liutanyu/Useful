/*                This file is part of the scheme package.
            Copyright (C) 1998-99 Stephane HILLION - hillion@essi.fr
                 http://www.essi.fr/~hillion/scheme-package
   scheme package is free software. You can redistribute it and/or modify it 
  under the terms of the GNU General Public License as published by the Free
  Software  Foundation;  either  version  2, or (at your option)  any  later 
  version. The  scheme package  is distributed in the hope that  it will  be
  useful, but  WITHOUT ANY WARRANTY;  without  even  the implied warranty of
  MERCHANTABILITY or  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General
  Public License for  more  details.   You  should  have  received a copy of
  the GNU General Public  License  along  with the scheme package;   see the
  file COPYING.  If not,  write to the Free  Software  Foundation,  Inc., 59
  Temple Place - Suite 330, Boston, MA 02111-1307, USA.
*/
package scheme.extensions;

import scheme.kernel.*;

/**
 * This procedure allows to call a redefined method
 *
 * @author  Stephane Hillion
 * @version 1.0 - 1998/11/30
 */
public class OScmSuper extends ScmPredefined implements OScmMethod, ScmSyntax {

  /**
   * The instance of this class
   */
  public final static OScmSuper INSTANCE = new OScmSuper ();

  /**
   * The action of the procedure.
   */
  protected ScmObject apply (ScmArray args, ScmStack envs) throws ScmException {
    if (args.size() < 2)
      error ("2 or more arguments expected");

    ScmObject arg = ScmKernel.evalAux2 (args.get(0), envs);

    if (!(arg instanceof OScmObject))
      error ("Object expected: "+arg);

    ScmSymbol name = toSymbol (args.get(1));

    OScmClass cl = ((OScmObject)arg).getObjectClass();
    boolean   ff = false;
    ScmObject obj = null;
    while (cl != null) {
      ScmEnvironment sh = cl.getShared();

      obj = sh.find (name);
      if (obj != null && !(obj instanceof OScmMethod))
	error (name.toString()+" is not a method");

      if (!ff && obj != null) {
	ff  = true;
	obj = null;
      } else if (ff && obj != null)
	break;
      
      if (cl == cl.getParent ())
	cl = null;
      else
	cl = cl.getParent ();
    }
    if (!ff || obj == null)
      error ("Super "+name+" do not exist");
    
    ScmProcedure proc = (ScmProcedure)obj;

    ScmArray params = new ScmArray ();
    params.add (arg);
    if (proc instanceof ScmSyntax) {
      for (int i = 2; i < args.size(); i++)
	params.add (args.get(i));
    } else {
      for (int i = 2; i < args.size(); i++)
	params.add (ScmKernel.evalAux2 (args.get(i), envs));
    }
      
    return proc.call (params, envs);
  }

  /** 
   * @return The external representation of the procedure
   */
  public String toString ()
  {
    return "#[method super]";
  }
}
