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
 * Java object type
 *
 * @author  Stephane Hillion
 * @version 1.0 - 1998/11/25
 */

public class ScmJavaObject extends ScmObject {
    /** The java object */
    private Object value;

    /** The null object */
    public static final ScmJavaObject NULL = new ScmJavaObject (null);

    /**
     * Create a new java object
     */
    public ScmJavaObject (Object val) {
	value = val;
    }

    /**
     * Reads the value of this object
     */
    public Object getValue () {
	return value;
    }

    /**
     * Object equality (address) 
     *
     * @param      obj - The object to test
     * @return     true if this and obj are references to the same object
     */
    public boolean isEq (ScmObject obj) {
	if (obj instanceof ScmJavaObject) {
	    return value == ((ScmJavaObject)obj).value;
	} else
	    return false;
    }

    /**
     * Object structural equality
     *
     * @param      obj - The object to test
     * @return     true if this and obj have the same structure
     */
    public boolean isEqual (ScmObject obj) {
	if (isEq (obj))
	    return true;

	if (obj instanceof ScmJavaObject) {
	    if (value == null)
		return (((ScmJavaObject)obj).value == null);
	    else
		if (((ScmJavaObject)obj).value == null)
		    return false;

	    return value.equals (((ScmJavaObject)obj).value);
	} else
	    return false;
    }

    /**
     * External representation
     */
    public String toString () {
	return "#[java-object \""+value+"\"]";
    }
  
    /**
     * External representation
     */
    public String toDisplayString () {
	return ""+value;
    }
  
}
