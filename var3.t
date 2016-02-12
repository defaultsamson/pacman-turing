/**********************************************************************/
/*     Program that allows the user to enter a number and print the   */
/*     number and its square on the screen                                   */
/*     illustrates the use of getch and locate                        */
/*     var3.t                                                          */
/**********************************************************************/

var number         : int    % the number input by the user
var number_squared : int    % the square of the number
var reply          : string(1)       % response to press enter to continue

const ROW : int := 10             % row position on the screen
const COL : int := 20            % column position on the screen


put "Enter a number "..
get number
number_squared := number * number
put number
put number_squared
locate (ROW,COL)
put "Press enter to continue "
getch (reply)                   % pauses execution until a key is pressed
cls

