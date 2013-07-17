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
 * Elements of the environment stack.
 *
 * @author  Stephane Hillion
 * @version 1.0 - 1998/11/09
 */
public class ScmEnvironment {
  /** The implementation */
  private ScmHashTable map;

  /**
   * Create a new empty environment element
   */
  public ScmEnvironment () {
    map = new ScmHashTable ();
  }

  /**
   * Create a new empty environment element
   * @param ic the initial capacity of the underlying map
   */
  public ScmEnvironment (int ic) {
    map = new ScmHashTable (ic);
  }

  /**
   * Binds a symbol to an object in this environment element
   * @param  symb - The symbol
   * @param  obj  - The object to bind with <code>symb</code>
   * @return The previous definition of symb or null
   */
  public ScmObject define (ScmSymbol symb, ScmObject obj) {
    return map.put (symb, obj);
  }

  /**
   * Finds the definition of the given symbol
   * @param  symb - The symbol
   * @return the binded object or null
   */
  public ScmObject find (ScmSymbol symb) {
    return map.get (symb);
  }

  /**
   * The external representation of this object
   * @return The string representing this object
   */
  public String toString () {
    return "#[environment "+hashCode()+"]";
  }
}
