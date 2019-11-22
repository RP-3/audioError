# Steps to replicate error:
```
Action         | stateBeforeAction | stateAfterAction
---------------+-------------------+-----------------------
1. Open app    | notPlaying        | notPlaying
2. Play audio  | notPlaying        | playing
3. Pause audio | playing           | notPlaying
4. Lock device | notPlaying        | notPlaying
5. Play audio  | notPlaying        | playing
6. Pause audio | notPlaying <---- What happened between 5 and 6??
```

## Other useful information
- Switching `AVAudioPlayer` for `AVPlayer`, and making no other changes at all makes the problem go away, leading me to believe this is an issue with `AVAudioPlayer`
  - See branch [AVPlayer](https://github.com/RP-3/audioError/compare/AVPlayer)
- Given that the issue seems to be related to invoking `AVAudioPlayer.play()` while in background, I figured this might have something to do with thread safety inside AVAudioPlayer.
  - Running `.play()` inside a `DispatchQueue.main {}` block does not fix it.
