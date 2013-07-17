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
package scheme.extensions;

import scheme.kernel.*;

/**
 * The classes in the object system
 *
 * @author  Stephane Hillion
 * @version 1.0 - 1998/11/29
 */
public class OScmClass extends OScmObject {
  /** The parent of this class */
  private OScmClass classParent;

  /** The fields of the instances of this class */
  private ScmArray fields;

  /** The shared fields of the instances of this class */
  private ScmEnvironment shared;
  
  /** The <class> object */
  public final static OScmClass CLASS;

  /** The <object> object */
  public final static OScmClass OBJECT;

  /** Static initializations */
  static {
    CLASS = new OScmClass (null, new ScmArray ());
    CLASS.objectClass = CLASS;
    OBJECT = new OScmClass (null, new ScmArray ());
    CLASS.classParent = OBJECT;
    OBJECT.classParent = OBJECT;

    CLASS.initClass ();
    OBJECT.initObject ();
  }

  /**
   * Create a new class
   */
  public OScmClass (OScmClass parent, ScmArray fields) {
    super (CLASS);
    classParent = parent;
    this.fields = fields;
    shared = new ScmEnvironment ();
  }

  /**
   * <class> initialization
   */
  private void initClass () {
    initObject ();
    shared.define (new ScmSymbol ("define"),     OScmDefine.INSTANCE);
    shared.define (new ScmSymbol ("get"),        OScmGet.INSTANCE);
    shared.define (new ScmSymbol ("get-parent"), OScmGetParent.INSTANCE);
    shared.define (new ScmSymbol ("make"),       OScmMakeClass.INSTANCE);
  }

  /**
   * <object> initialization
   */
  private void initObject () {
    shared.define (new ScmSymbol ("get-class"), OScmGetClass.INSTANCE);
    shared.define (new ScmSymbol ("super"),     OScmSuper.INSTANCE);
  }

  /**
   * Gets the fields
   */
  public ScmArray getFields () {
    return fields;
  }

  /**
   * Gets the shared fields
   */
  public ScmEnvironment getShared () {
    return shared;
  }

  /**
   * Gets the parent
   */
  public OScmClass getParent () {
    return classParent;
  }

  /** 
   * @return The external representation of the procedure
   */
  public String toString () {
    return "#[class "+hashCode()+"]";
  }
}
