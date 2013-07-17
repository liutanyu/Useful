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
 * A resizable array designed for this package
 *
 * @author  Stephane Hillion
 * @version 1.0 - 1998/11/23
 */

public class ScmArray {
  /** The implementation */
  private ScmObject [] array;

  /** The number of items in the array */
  private int count;

  /**
   * The default constructor: create an empty array 
   */
  public ScmArray () {
    array = new ScmObject [11];
    count = 0;
  }

  /**
   * Encapsulates a Java array in this array.
   * @param tab an array with no null references
   */
  public ScmArray (ScmObject [] tab) {
    array = tab;
    count = tab.length;
  }

  /**
   * Gets an element of the array
   * @param i the index of the element in the range [0, size()[
   */
  public ScmObject get (int i) {
    return array [i];
  }

  /**
   * Sets an element in the array
   * @param i   the index of the element to set
   * @param obj the object to set
   */
  public void set (int i, ScmObject obj) {
    array [i] = obj;
  }

  /**
   * Adds an element at the end of the array
   * @param obj the element to add
   */
  public void add (ScmObject obj) {
    if (count == array.length)
      resize ();
    array [count++] = obj;
  }

  /**
   * Returns the size of this array
   */
  public int size () {
    return count;
  }

  /**
   * Returns a sub array of this array
   * @param i1 the index of the first element to place in the result
   * @param i2 the index of the element after the last to include
   */
  public ScmArray subArray (int i1, int i2) {
    ScmArray res = new ScmArray ();
    for (int i = i1; i < i2; i++)
      res.add (get (i));
    return res;
  }

  /**
   * Resizes the array
   */
  private void resize () {
    ScmObject [] tmp = new ScmObject [array.length*2+1];
    for (int i = 0; i < array.length; i++)
      tmp [i] = array [i];
    array = tmp;
  }
}
