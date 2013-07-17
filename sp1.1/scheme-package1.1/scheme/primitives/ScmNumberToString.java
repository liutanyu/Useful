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
 * The Scheme language 'number->string' procedure
 *
 * @author  Stephane Hillion
 * @version 1.0 - 1998/11/24
 */
public class ScmNumberToString extends ScmPredefined {

  /**
   * The instance of this class
   */
  public final static ScmNumberToString INSTANCE = new ScmNumberToString ();

  /**
   * The action of the procedure
   */
  protected ScmObject apply (ScmArray args, ScmStack envs) throws ScmException {
    if (args.size() != 1 && args.size() != 2)
      error ("1 or 2 arguments expected");

    ScmNumber numb = toNumber (args.get(0));
    int       base = (args.size() == 1)?
	10:
	toInteger(args.get(1)).getValue();

    if (numb instanceof ScmInteger)
      return new ScmString (Integer.toString (((ScmInteger)numb).getValue(), base));
    else {
      if (base != 10)
	error ("Bad radix: "+base);
      return new ScmString (Double.toString (((ScmReal)numb).getValue()));
    }
  }

  /** 
   * @return The external representation of the procedure
   */
  public String toString () {
    return "#[primitive number->string]";
  }
}
