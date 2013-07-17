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
 * Scheme language vector type
 *
 * @author  Stephane Hillion
 * @version 1.1 - 1998/12/10
 */

public class ScmVector extends ScmObject {
  /** Implementation */
  private ScmObject [] value;

  /**
   * Create a new vector
   * @param len the size of this vector
   */
  public ScmVector (int len) {
    value = new ScmObject [len];
    for (int i = 0; i < len; i++)
      value [i] = ScmPair.NULL;
  }

  /**
   * Create a new vector
   * @param len the size of the vector
   * @param object the object the vector is filled with
   */
  public ScmVector (int len, ScmObject object) {
    this (len);

    for (int i = 0; i < len; i++)
      value [i] = object;
  }

  /**
   * Create a new vector
   * @param vec this vector is a copy of arr
   */
  public ScmVector (ScmArray arr) {
    value = new ScmObject [arr.size()];
    
    for (int i = 0; i < arr.size(); i++)
      value [i] = arr.get (i);
  }

  /**
   * Create a new vector
   */
  public ScmVector (ScmObject [] arr) {
    value = arr;
  }

  /**
   * Object structural equality
   *
   * @param      obj - The object to test
   * @return     true if this and obj have the same structure
   */
  public boolean isEqual (ScmObject obj) {
    if (this == obj)
      return true;

    if (getClass () != obj.getClass ())
      return false;

    if (value.length != ((ScmVector)obj).value.length)
      return true;

    for (int i = 0; i < value.length; i++)
      if (!value [i].isEqual (((ScmVector)obj).value [i]))
	return false;

    return true;
  }

  /**
   * The java array
   */
  public ScmObject [] getValue() {
    return value;
  }

  /**
   * The array length
   */
  public int getLength() {
    return value.length;
  }

  /** 
   * External representation
   */
  public String toString () {
    String res = "#(";

    if (value.length > 0)
      res = res + value [0];

    for (int i = 1; i < value.length; i++)
      res = res + " " + value [i];

    return res + ")";
  }

  /** 
   * External representation
   */
  public String toDisplayString () {
    String res = "#(";

    if (value.length > 0)
      res = res + value [0].toDisplayString();

    for (int i = 1; i < value.length; i++)
      res = res + " " + value [i].toDisplayString();

    return res + ")";
  }

}
