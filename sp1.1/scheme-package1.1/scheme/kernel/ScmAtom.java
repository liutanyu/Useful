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
 * The parent of all Scheme atoms
 *
 * @author  Stephane Hillion
 * @version 1.0 - 1998/11/10
 */
public abstract class ScmAtom extends ScmObject {
  
  /**
   * Object equality for atoms
   * @param      obj The object to test
   * @return     true if this and obj are references to the same object
   */
  public boolean isEq (ScmObject obj) {
    return isEqual(obj);
  }

  /**
   * Object structural equality
   * @param      obj The object to test
   * @return     true if this and obj have the same structure
   */
  public boolean isEqual (ScmObject obj) {
    if (this == obj)
      return true;

    if (getClass() != obj.getClass())
      return false;

    return atomEqual((ScmAtom)obj);
  }

  /**
   * Tests the equality of two atoms of the same class
   * @param  other The other atom to test
   * @return true if this equals other
   */
  protected abstract boolean atomEqual (ScmAtom other);

}
