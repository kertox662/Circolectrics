/*


<Layer>
<\Layer>
Different components will be saved in a format similar to html tags.
The current tags are:
<Layer>
<Track>
<Component>
<Text>
Along with backslash variants



//Each layer will start with a layer tag.
<Layer>
30 //default Thickness
Name
Color
//Each element of the layer follows in their own tags.
<Track>
//Points follow with commas
100,200
50,150
</Track>
</Layer>




===Layer===
<Layer>
Thickness
Name
Color
</Layer>

===Track===
<Track>
Point 1 (x,y)
Point 2 (x,y)
(Optional) Thickness
</Track>

===Component===
<Component>
Part Type
---------Not Sure Yet-------------
Base Point (x,y)
Rotation
-----------Or---------------
Pad 1
Pad 2
Etc.
---------------------------------

===Text===
<Text>
Text
Font Size
Base Point
</Text>

*/
