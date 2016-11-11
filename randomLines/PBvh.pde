public class PBvh
{
  public BvhParser parser;  

  public PBvh(String[] data)
  {
    parser = new BvhParser();
    parser.init();
    parser.parse( data );
  }
  
  public void update( int ms )
  {
    parser.moveMsTo( ms );//30-sec loop 
    parser.update();
  }
  
  public void draw()
  {    
    ArrayList<BvhBone> bones = new ArrayList<BvhBone>();
    for( int i = 0; i<parser.getBones().size(); i++) {
      bones.add(parser.getBones().get(i));
    }
    
    for(int i=0; i<bones.size(); i++) {
      BvhBone b1 = bones.get(i);
      BvhBone b2 = bones.get(int(random(bones.size())));
      BvhBone b3 = bones.get(int(random(bones.size())));

      fill(0, 199, 140, 50);
      noStroke();
      beginShape();
      vertex(b1.absPos.x, b1.absPos.y, b1.absPos.z);
      vertex(b2.absPos.x, b2.absPos.y, b2.absPos.z);
      vertex(b3.absPos.x, b3.absPos.y, b3.absPos.z);
      endShape(CLOSE);
    }
  }
}