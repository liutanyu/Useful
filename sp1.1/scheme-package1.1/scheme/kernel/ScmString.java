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
 * Scheme string type
 *
 * @author  Stephane Hillion
 * @version 1.1 - 1998/12/10
 */

public class ScmString extends ScmAtom {
  // Private members
  //
  private char [] value;
  private boolean immutable = false;

  /**
   * Create a new string
   */
  public ScmString (String val) {
    value = val.toCharArray();
    immutable = true;
  }

  /**
   * Create a new string
   */
  public ScmString (String val, boolean imm) {
    value = val.toCharArray();
    immutable = imm;
  }

  /**
   * Create a new string
   */
  public ScmString (char [] val) {
    value = val;
  }

  /**
   * Create a new string
   */
  public ScmString (int len) {
    value = new char [len];
    for (int i = 0; i < len; i++) value [i] = ' ';
  }

  /**
   * Create a new string
   */
  public ScmString (ScmSymbol symb) {
    value = symb.toString().toCharArray();
    immutable = true;
  }

  /**
   * Create a new string
   */
  public ScmString (ScmArray lst) {
    value = new char [lst.size()];
    for (int i = 0; i < lst.size(); i++)
      value [i] = ((ScmChar)lst.get(i)).getValue();
  }

  /**
   * Create a new string
   * @param len string's length
   * @param c   fill character
   */
  public ScmString (int len, char c) throws ScmException {
    if (len < 0)
      throw new ScmException (" length can't be negative");

    value = new char [len];
    for (int i = 0; i < len; i++) value [i] = c;
  }

  /**
   * Reads the value of this string
   */
  public char [] getValue () {
    return value;
  }

  /**
   * Reads the length of this string
   */
  public int getLength () {
    return value.length;
  }

  /**
   * Is this string mutable?
   */
  public boolean isMutable () {
    return !immutable;
  }

  /**
   * Compare this string with other
   */
  public int compareTo (ScmString other) {
    return toStringWithoutQuotes().compareTo (other.toStringWithoutQuotes());
  }

  /**
   * Compare this string with other ignoring case considerations
   */
  public int compareCITo (ScmString other) {
    return toStringWithoutQuotes().toLowerCase().compareTo
	(other.toStringWithoutQuotes().toLowerCase());
  }

  /**
   * Gets a copy of this string
   */
  public ScmString getCopy() {
    char [] cp = new char [value.length];
    for (int i = 0; i < value.length; i++)
      cp [i] = value [i];

    return new ScmString (cp);
  }

  /**
   * External representation
   */
  public String toString () {
    String res = "\"";

    for (int i = 0; i < value.length; i++) {
      if (value [i] == '"'  || value [i] == '\\')
	res += "\\";
      
      res += value [i];
      }

    return res + "\"";
  }
  
  /**
   * External representation of this object
   */
  public String toDisplayString () {
    return new String(value);
  }

  /**
   * External representation without quotes
   */
  public String toStringWithoutQuotes () {
    return new String(value);
  }
  
  public boolean isEq (ScmObject other) {
    return this == other;
  }

  protected boolean atomEqual (ScmAtom other) {
    return new String(value).equals(new String(((ScmString)other).value));
  }

}
