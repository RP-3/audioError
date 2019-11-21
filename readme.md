# Steps to replicate error:
```
Action 	       | stateBeforeAction | stateAfterAction
---------------+-------------------+-----------------------
1. Open app    | notPlaying        | notPlaying
2. Play audio  | notPlaying	   | playing
3. Pause audio | playing	   | notPlaying
4. Lock device | notPlaying	   | notPlaying
5. Play audio  | notPlaying 	   | playing
6. Pause audio | notPlaying <---- What happened between 5 and 6??
```
