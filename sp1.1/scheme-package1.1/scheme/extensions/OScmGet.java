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
 * This procedure gets the value of a class variable
 *
 * @author  Stephane Hillion
 * @version 1.0 - 1998/11/30
 */
public class OScmGet extends ScmPredefined implements OScmMethod, ScmSyntax {

  /**
   * The instance of this class
   */
  public final static OScmGet INSTANCE = new OScmGet ();

  /**
   * The action of the procedure.
   */
  protected ScmObject apply (ScmArray args, ScmStack envs) throws ScmException {
    if (args.size() != 2)
      error ("2 arguments expected");

    if (!(args.get(0) instanceof OScmClass))
      error ("Class expected: "+args.get(0));

    OScmClass cl   = (OScmClass)args.get(0);
    ScmSymbol name = toSymbol(args.get(1));

    while (cl != null) {
      ScmEnvironment sh = cl.getShared();

      ScmObject obj = sh.find (name);

      if (obj != null)
	return obj;
      
      if (cl == cl.getParent ())
	cl = null;
      else
	cl = cl.getParent ();
    }
    error ("Class value is unbound: "+name);
    return ScmUndefined.UNDEFINED;
  }

  /** 
   * @return The external representation of the procedure
   */
  public String toString ()
  {
    return "#[method get]";
  }
}
