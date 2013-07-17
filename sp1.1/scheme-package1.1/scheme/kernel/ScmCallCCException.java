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
 * The exception thrown when a call/cc occured
 *
 * @author  Stephane Hillion
 * @version 1.0 - 1998/11/10
 */
public class ScmCallCCException extends ScmException {
  
  // Private members
  //
  private ScmObject result;

  /**
   * Constructor
   * @param obj - The result of the call/cc
   */
  public ScmCallCCException (ScmObject obj) {
    super ("Current continuation");
    result = obj;
  }

  /**
   * @return The result of the call/cc
   */
  public ScmObject getResult () {
    return result;
  }
}
