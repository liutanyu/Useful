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
 * Converts a Scheme integer to a Java long
 *
 * @author  Stephane Hillion
 * @version 1.0 - 1998/11/24
 */
public class ScmIntegerToJavaLong extends ScmPredefined {

  /**
   * The instance of this class
   */
  public final static ScmIntegerToJavaLong INSTANCE = new ScmIntegerToJavaLong ();

  /**
   * The action of the procedure
   */
  protected ScmObject apply (ScmArray args, ScmStack envs) throws ScmException {
    if (args.size() != 1)
      error ("1 argument expected");

    return new ScmJavaObject (new Long(toInteger(args.get(0)).getValue()));
  }

  /** 
   * @return The external representation of the procedure
   */
  public String toString () {
    return "#[primitive integer->java-long]";
  }
}
