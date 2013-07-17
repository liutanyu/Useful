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
 * The scheme boolean type
 *
 * @author  Stephane Hillion
 * @version 1.0 - 1998/11/12
 */

public class ScmBoolean extends ScmAtom {
  /** Implementation */
  private boolean value;

  /** 
   * The #t object
   */
  public final static ScmBoolean T = new ScmBoolean (true);

  /**
   * The #f object
   */
  public final static ScmBoolean F = new ScmBoolean (false);

  /** 
   * Creates a new boolean
   * @param val true or false
   */
  protected ScmBoolean (boolean val) {
    value = val;
  }

  /**
   * Casts this <code>ScmBoolean</code> in a Java boolean
   */
  public boolean getValue() {
    return value;
  }

  /**
   * The external representation of this object
   */
  public String toString () {
    return value ? "#t" : "#f";
  }

  /**
   * Tests the equality of two booleans
   * @param other a <code>ScmBoolean</code>
   */
  protected boolean atomEqual (ScmAtom other) {
    return this == other;
  }
}
