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
 * The end of file object
 *
 * @author  Stephane Hillion
 * @version 1.0 - 1998/11/26
 */

public class ScmEOF extends ScmObject {
  /**
   * The EOF object
   */
  public final static ScmEOF INSTANCE = new ScmEOF ();

  /**
   * Protected constructor because only one instance is needed
   */
  protected ScmEOF () {
  }

  /**
   * Object structural equality
   * @param      obj - The object to test
   * @return     true if this and obj have the same structure
   */
  public boolean isEqual (ScmObject obj) {
    return this == INSTANCE;
  }

  /**
   * The external representation of this object
   */
  public String toString ()
  {
    return "#[eof-object]";
  }
}
