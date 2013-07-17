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
 * The instances in the object system
 *
 * @author  Stephane Hillion
 * @version 1.0 - 1998/11/29
 */
public class OScmObject extends ScmPredefined implements ScmSyntax {
  /** The class of this object */
  protected OScmClass objectClass;

  /** The environment containing the fields of this object */
  private ScmEnvironment fields;

  /** The 'this' symbol */
  public final static ScmSymbol THIS = new ScmSymbol ("this");

  /**
   * Create a new object
   */
  public OScmObject (OScmClass objectClass) {
    this.objectClass = objectClass;

    createFields ();
  }

  /**
   * Gets the fields of this object
   */
  public ScmEnvironment getFieldEnvironment () {
    return fields;
  }

  /**
   * The action of the procedure.
   */
  protected ScmObject apply (ScmArray args, ScmStack envs) throws ScmException {
    if (args.size() < 1)
      error ("1 or more arguments expected");

    ScmProcedure proc = findMethod (toSymbol (args.get(0)));

    ScmArray params = new ScmArray ();
    params.add (this);
    if (proc instanceof ScmSyntax) {
      for (int i = 1; i < args.size(); i++)
	params.add (args.get(i));
    } else {
      for (int i = 1; i < args.size(); i++)
	params.add (ScmKernel.evalAux2 (args.get(i), envs));
    }
      
    return proc.call (params, envs);
  }

  /**
   * Finds a method
   */
  private ScmProcedure findMethod (ScmSymbol name) throws ScmException {
    OScmClass cl = objectClass;

    while (cl != null) {
      ScmEnvironment sh = cl.getShared();

      ScmObject obj = sh.find (name);
      if (obj != null && !(obj instanceof OScmMethod))
	error (name.toString()+" is not a method");

      if (obj != null)
	return (ScmProcedure)obj;
      
      if (cl == cl.getParent ())
	cl = null;
      else
	cl = cl.getParent ();
    }
    error (name.toString()+" do not exist");
    return null;
  }

  /**
   * The class of this object
   */
  public OScmClass getObjectClass () {
    return objectClass;
  }

  /** 
   * @return The external representation of the procedure
   */
  public String toString () {
    return "#[object "+hashCode()+"]";
  }

  /**
   * Creates the fields of this object
   */
  private void createFields () {
    OScmClass cl = objectClass;

    fields = new ScmEnvironment ();

    while (cl != null) {
      ScmArray f = cl.getFields ();

      for (int i = 0; i < f.size(); i++)
	fields.define ((ScmSymbol)f.get(i), ScmUndefined.UNDEFINED);

      if (cl == cl.getParent ())
	cl = null;
      else
	cl = cl.getParent ();
    }
  }
}
