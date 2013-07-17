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
 * This procedure creates a new class or a new object
 *
 * @author  Stephane Hillion
 * @version 1.0 - 1998/11/29
 */
public class OScmMakeClass extends ScmPredefined implements OScmMethod, ScmSyntax {

  /**
   * The instance of this class
   */
  public final static OScmMakeClass INSTANCE = new OScmMakeClass ();

  /**
   * The action of the procedure.
   */
  protected ScmObject apply (ScmArray args, ScmStack envs) throws ScmException {
    if (args.size() < 1)
      error ("Bad number of arguments");

    ScmObject cl = ScmKernel.evalAux2 (args.get(0), envs);

    if (cl == OScmClass.CLASS) {
      if (args.size() != 3)
	error ("3 arguments expected");

      ScmObject arg2 = ScmKernel.evalAux2 (args.get(1), envs);

      if (!(arg2 instanceof OScmClass))
	error ("Argument 2 must be a class: "+args.get(1));

      if (args.get(1) == OScmClass.CLASS)
	error ("Can't subclass <class>");

      ScmPair  fields = toPair(args.get(2));
      ScmArray f = new ScmArray ();

      while (fields != ScmPair.NULL) {
	f.add (toSymbol (fields.getCar()));
	fields = toPair (fields.getCdr());
      }

      return new OScmClass ((OScmClass)arg2, f);
    } else {
      ScmArray a = new ScmArray ();
      a.add (cl);
      for (int i = 1; i < args.size(); i++)
	a.add (ScmKernel.evalAux2 (args.get(i), envs));
      return OScmMakeObject.INSTANCE.apply (a, envs);
    }
  }

  /** 
   * @return The external representation of the procedure
   */
  public String toString ()
  {
    return "#[method make]";
  }
}
