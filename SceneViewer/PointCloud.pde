/*\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 *
 *  Copyright 2008 Aaron Koblin
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *
 *//////////////////////////////////////////////////////////////

// OpenGL trickery for point rendering. Buffers make things speedy!

import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.nio.FloatBuffer;
import javax.media.opengl.GL2;

public class VBPointCloud {
  PApplet p;
  GL2 gl;
  PGraphicsOpenGL pg;
  PGL pgl;
  public float pointSize = .5f;
  FloatBuffer f, c;

  public VBPointCloud(PApplet p) {
    this.p = p;
    this.pg = (PGraphicsOpenGL) p.g;
  }

  public void loadFloats(float[] points) {
    f = ByteBuffer.allocateDirect(4 * points.length).order(
    ByteOrder.nativeOrder()).asFloatBuffer();
    f.put(points);
    f.rewind();
  }

  public void loadFloats(float[] points, float[] colors) {
    f = ByteBuffer.allocateDirect(4 * points.length).order(
    ByteOrder.nativeOrder()).asFloatBuffer();
    f.put(points);
    f.rewind();
    c = ByteBuffer.allocateDirect(4 * colors.length).order(
    ByteOrder.nativeOrder()).asFloatBuffer();
    c.put(colors);
    c.rewind();
  }

  public void draw() {
    pg = (PGraphicsOpenGL)g;
    pgl = beginPGL();
    gl = ((PJOGL)pgl).gl.getGL2();

    gl.glPointSize(pointSize);

    //GL doesnt take Processing's color values ... so I'm doin it here!
    int c = p.g.strokeColor;
    gl.glColor4f(p.red(c)/255f,p.green(c)/255f,p.blue(c)/255f,p.alpha(c)/255f);

    //I'll help you make it look a little pretty
    gl.glEnable(GL2.GL_POINT_SMOOTH);
    gl.glDisable(GL2.GL_DEPTH_TEST);
    gl.glEnable(GL2.GL_BLEND);
    gl.glBlendFunc(GL2.GL_SRC_ALPHA, GL2.GL_ONE);

    gl.glEnableClientState(GL2.GL_VERTEX_ARRAY);
    // gl.glEnableClientState(GL.GL_COLOR_ARRAY);
    gl.glVertexPointer(3, GL2.GL_FLOAT, 0, f);
    // gl.glColorPointer(4,GL.GL_FLOAT,0,c);
    gl.glDrawArrays(GL2.GL_POINTS, 0, f.capacity() / 3);
    gl.glDisableClientState(GL2.GL_VERTEX_ARRAY);
    endPGL();
  }
}
