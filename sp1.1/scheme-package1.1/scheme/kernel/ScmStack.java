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
 * A stack designed for this package
 *
 * @author  Stephane Hillion
 * @version 1.1 - 1998/12/24
 */
public class ScmStack {
  // Private members
  //
  private Link  head  = null;
  private Link  first = null;

  /** A list of reusable links */
  private static Link freeLinks = null;

  /**
   * Constructor: build an empty stack
   */
  public ScmStack () {
  }
  
  /**
   * Private constructor
   */
  private ScmStack (ScmStack stk) {
    head  = stk.head;
    first = stk.first;
  }

  /**
   * Pushes an object on the stack
   * @param obj - The object to push
   */
  public void push (Object obj) {
    Link oldHead = head;

    if (freeLinks != null) {
      head = freeLinks;
      freeLinks = freeLinks.tail;
      head.item = obj;
      head.tail = oldHead;
    } else
      head = new Link (obj, head);
    if (oldHead == null)
      first = head;
  }

  /**
   * Pushes an object on the stack
   * @param obj - The object to push
   */
  public void pushReusable (Object obj) {
    Link oldHead = head;

    if (freeLinks != null) {
      head = freeLinks;
      freeLinks = freeLinks.tail;
      head.item = obj;
      head.tail = oldHead;
    } else
      head = new Link (obj, head);

    head.reusable = true;
    if (oldHead == null)
      first = head;
  }

  /**
   * Adds an item at the bottom of the stack
   */
  public void addLast (Object obj) {
    if (first == null) {
      if (freeLinks != null) {
	first = freeLinks;
	freeLinks = freeLinks.tail;
	first.item = obj;
	first.tail = null;
      } else
	first = new Link (obj, null);
      head  = first;
    } else {
      if (freeLinks != null) {
	first.tail = freeLinks;
	freeLinks = freeLinks.tail;
	first.tail.item = obj;
	first.tail.tail = null;
      } else
	first.tail = new Link (obj, null);
      first = first.tail;
    }
  }

  /**
   * Adds an item at the bottom of the stack
   */
  public void addReusableLast (Object obj) {
    if (first == null) {
      if (freeLinks != null) {
	first = freeLinks;
	freeLinks = freeLinks.tail;
	first.item = obj;
	first.tail = null;
      } else
	first = new Link (obj, null);
      head  = first;
    } else {
      if (freeLinks != null) {
	first.tail = freeLinks;
	freeLinks = freeLinks.tail;
	first.tail.item = obj;
	first.tail.tail = null;
      } else
	first.tail = new Link (obj, null);
      first = first.tail;
    }
    first.reusable = true;
  }

  /**
   * Pops the object at the top of the stack.
   * The link is put in the list of reusable links.
   * @return  The deleted object
   * @require !empty()
   * @ensure  result != null
   */
  public Object pop () {
    Link tmp = head;

    head = head.tail;
    if (head == null)
      first = null;

    if (tmp.reusable) {
      tmp.reusable = false;
      tmp.tail     = freeLinks;
      freeLinks    = tmp;
    }

    return tmp.item;
  }

  /**
   * @return the object on the top of the stack
   * @require !empty()
   * @ensure  result != null
   */
  public Object peek () {
    return head.item;
  }

  /**
   * @return a clone of this stack
   */
  public Object clone () {
    return new ScmStack (this);
  }

  /**
   * Tests the state of this stack
   * @return true if the stack is empty
   */
  public boolean empty () {
    return head == null;
  }

  /**
   * @return the first element of this stack
   * @require !empty()
   * @ensure  result != null
   */
  public Object firstElement () {
    return first.item;
  }

  /**
   * Implementation class
   */
  private static class Link {
    // Fields
    //
    Object  item;
    Link    tail;
    boolean reusable;

    /**
     * Create a new link
     */
    public Link (Object obj, Link lnk) {
      item     = obj;
      tail     = lnk;
      reusable = false;
    }
  }
}
