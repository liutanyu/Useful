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
package scheme.kernel;

/**
 * The scheme char type
 *
 * @author  Stephane Hillion
 * @version 1.0 - 1998/11/12
 */

public class ScmChar extends ScmAtom {
  /** Implementation */
  private char value;

  /**
   * Creates a new char
   * @param val the value of this object
   */
  public ScmChar (char val) {
    value = val;
  }

  /**
   * Casts this object into a Java char
   */
  public char getValue() {
    return value;
  }

  /**
   * Returns the external representation of this object
   */
  public String toString () {
    switch (value) {
    case 0  : return "#\\null";
    case 1  : return "#\\soh";
    case 2  : return "#\\stx";
    case 3  : return "#\\etx";
    case 4  : return "#\\eot";
    case 5  : return "#\\enq";
    case 6  : return "#\\ack";
    case 7  : return "#\\bell";
    case 8  : return "#\\backspace";
    case 9  : return "#\\ht";
    case 10 : return "#\\newline";
    case 11 : return "#\\vt";
    case 12 : return "#\\page";
    case 13 : return "#\\return";
    case 14 : return "#\\so";
    case 15 : return "#\\si";
    case 16 : return "#\\dle";
    case 17 : return "#\\dc1";
    case 18 : return "#\\dc2";
    case 19 : return "#\\dc3";
    case 20 : return "#\\dc4";
    case 21 : return "#\\nak";
    case 22 : return "#\\syn";
    case 23 : return "#\\etb";
    case 24 : return "#\\can";
    case 25 : return "#\\em";
    case 26 : return "#\\sub";
    case 27 : return "#\\escape";
    case 28 : return "#\\fs";
    case 29 : return "#\\gs";
    case 30 : return "#\\rs";
    case 31 : return "#\\us";
    case 32 : return "#\\space";
    default : return "#\\"+value;
    }
  }

  /**
   * The external representation in the 'display' form
   */
  public String toDisplayString () {
    return String.valueOf (value);
  }

  /**
   * Tests the equality of two <code>ScmChar</code>
   */
  protected boolean atomEqual (ScmAtom other)
  {
    return value == ((ScmChar)other).value;
  }
}
