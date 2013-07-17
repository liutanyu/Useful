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
package scheme.primitives;

import scheme.kernel.*;

/**
 * The Scheme language 'substring' procedure
 *
 * @author  Stephane Hillion
 * @version 1.0 - 1998/11/25
 */
public class ScmSubstring extends ScmPredefined {

  /**
   * The instance of this class
   */
  public final static ScmSubstring INSTANCE = new ScmSubstring ();

  /**
   * The action of the procedure
   */
  protected ScmObject apply (ScmArray args, ScmStack envs) throws ScmException {
    if (args.size() != 3)
      error ("3 arguments expected");

    char[] str = toScmString (args.get(0)).getValue();
    int    i1  = toInteger   (args.get(1)).getValue();
    int    i2  = toInteger   (args.get(2)).getValue();

    if (i1 < 0 || i1 > str.length ||
	i2 < 0 || i2 > str.length ||
	i1 > i2)
      error ("Bad indexes: "+i1+", "+i2);

    char [] res = new char [i2-i1];
    for (int i = i1; i < i2; i++)
      res [i-i1] = str [i];

    return new ScmString (res);
  }

  /** 
   * @return The external representation of the procedure
   */
  public String toString () {
    return "#[primitive substring]";
  }
}
