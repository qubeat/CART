Wireless Ants World  
A.Yu.Vlasov  

Reversible cellular automaton with four states based on irreversible CA with two states.
---------------------------------------------------------------------------------------
 
Rule WlAnt:

There are four states: 0 (empty, white), 1 (red), 2 (green), 3 (blue).

A cell with state 0 or 2 (white or green) is called "even"
and a cell with state 1 or 3 (red or blue) is called "odd"

A step may be divided into two stages:

First stage:  
Mark all cells satisfying two conditions:   
(1) total number of odd cells in four closest positions (up, down, left, right) is one or two,    
(2) cells in four diagonal positions are even.  

Second stage:  
For unmarked: exchange red and green cells (1<->2).  
For marked cells: change empty into red, red into blue, blue into green, 
green into empty (0->1->3->2->0).

---------------------------------------------------------------------------------------

Four modifications of the WlAnt rule have differences only in condition (1) in the first stage

WlAnt-2 - total number of odd cells in closest positions is any nonzero number (1,2,3,4)

WlAnt-3 - total number of odd cells in closest positions is one, two or three

WlAnt-4 - total number of odd cells in closest positions is either one 
          or two in _opposite_ positions (i.e. up/down or left/right)

---------------------------------------------------------------------------------------

WlSnake - total number of odd cells in closest positions is one

WlSnake-3 - total number of odd cells in closest positions is one or three

---------------------------------------------------------------------------------------


See also, WlAnt:

http://ayvlasov.wordpress.com/2012/07/23/qu-ants/  
http://quantumbot.wordpress.com/2013/07/27/reversible-anto-logic/  
http://quantumbot.wordpress.com/2013/08/07/conservative-anto-logic/  
http://ayvlasov.wordpress.com/2014/01/11/wireless-ants-world/  

3D versions:  
http://ayvlasov.wordpress.com/2013/07/31/flying-bricks-ca/  
http://ayvlasov.wordpress.com/2016/05/12/3d-cellular-automata-animation/  

WlSnake - "Wireless Snakes". More about the "snakes" rule:  

http://ayvlasov.wordpress.com/2014/04/26/conserved-ants/  

http://ayvlasov.wordpress.com/2014/06/28/snakes-and-fractals/  
With two integer sequences based on the rule:  
http://oeis.org/A244642  
http://oeis.org/A244643  

A bit more:  
http://ayvlasov.wordpress.com/2014/07/02/snake-in-the-cloud/  
http://ayvlasov.wordpress.com/2014/07/15/deceptive-arrows/  

3D version:  
https://ayvlasov.wordpress.com/2014/07/25/snake-in-3d-and-nim/  

