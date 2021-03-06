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

import java.lang.reflect.*;
import scheme.kernel.*;

/**
 * The interface to "Field.get()" method
 *
 * @author  Stephane Hillion
 * @version 1.0 - 1998/11/25
 */
public class ScmJavaFieldGet extends ScmPredefined {

    /**
     * The instance of this class
     */
    public final static ScmJavaFieldGet INSTANCE = new ScmJavaFieldGet ();

    /**
     * The action of the procedure
     */
    protected ScmObject apply (ScmArray args, ScmStack envs) throws ScmException {
	if (args.size() != 2)
	    error ("2 arguments expected");


	if (!(args.get(0) instanceof ScmJavaObject))
	    error ("java-object expected: "+args.get(0));

	if (!(args.get(1) instanceof ScmJavaObject))
	    error ("java-object expected: "+args.get(1));

	ScmJavaObject obj1 = (ScmJavaObject)args.get(0);
	ScmJavaObject obj2 = (ScmJavaObject)args.get(1);

	if (!(obj1.getValue() instanceof Field))
	    error ("First argument must be a field: "+obj1);


	try {
	    return new ScmJavaObject (((Field)obj1.getValue()).get(obj2.getValue()));
	} catch (IllegalAccessException e1) {
	    error("Illegal access: "+e1);
	} catch (IllegalArgumentException e2) {
	    error ("Illegal argument: "+e2);
	} catch (NullPointerException e3) {
	    error ("Null pointer: "+e3);
	}
	return ScmUndefined.UNDEFINED;
    }

  /** 
   * @return The external representation of the procedure
   */
  public String toString () {
    return "#[primitive java-field-get]";
  }
}
