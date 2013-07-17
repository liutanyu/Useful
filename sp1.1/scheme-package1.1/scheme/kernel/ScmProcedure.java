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
 * All scheme procedures must subclass ScmProcedure
 *
 * @author  Stephane Hillion
 * @version 1.0 - 1998/11/10
 */
public abstract class ScmProcedure extends ScmObject {
  /**
   * Cause the execution of the procedure
   * @param args - The arguments of the procedure
   * @param envs - The environment of execution
   */
  public ScmObject call (ScmArray args, ScmStack envs) throws ScmException {
    return apply (args, envs);
  }

  /**
   * The action of the procedure
   */
  protected abstract ScmObject apply (ScmArray args, ScmStack envs) throws ScmException;

}
