# Pishock Roulette
Russian Roulette, except it's a video game, except it can still kill you. (technically)

Wouldn't it be fun to play a video game and really *feel* the emotions that the ingame character is feeling? Well, with this small modification, you can!
It's just like you're playing the real game, except condensed down to a small monitor right in front of you.

Pishock Roulette patches the game [Buckshot Roulette](https://store.steampowered.com/app/2835570/Buckshot_Roulette/) and makes it write "player_shot" to the console,
whenever you take damage in the game. This includes damage from pills.

> [!WARNING]
> I'm not responsible for any damages done by this project (AI wrote most of this anyways, do I look like I know how to write bash scripts).
> Please be careful.

> [!IMPORTANT]
> For legal reasons, this tool was not designed to be used on animals or humans. You can probably get away with using it on aliens, if you find any.
> I'm not sure how this rule extends to catgirls and other hybrids.. ask your lawyer

## How do I use it?
Well, first of all you're going to need a [shock collar](https://pishock.com/). Then you're going to need [Buckshot Roulette on Steam](https://store.steampowered.com/app/2835570/Buckshot_Roulette/) though you might be able to make this work with [itch.io](https://mikeklubnika.itch.io/buckshot-roulette) version as well.

Now, create a file called `shockenv.sh` and enter your secrets:
```bash
#!/bin/bash
export PISHOCK_USER="Username"
export PISHOCK_API_KEY="xxxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxx"
export PISHOCK_CODE="FFFFFFFFFFF"
```

Then, open `start.sh` and adjust the intensity and duration to what you can handle.
```bash
...

# Configure shock (can only be the same as on the web interface)
MIN_INTENSITY=20
MAX_INTENSITY=30
DURATION=0.3

...
```

Finally, run `./start.sh` and enjoy the game!

## I'm on Windows/Mac
While the scripts were written to work on linux, you can still manually make this work. The game is written in GDScript and assuming the windows build has the same plain code in the executable, the patches should still work. You should manually verify that the indices are correct (grab the linux patch and compare). Now, write your own logic for patching, shocking, launching and reading console output (without buffering) and you should be good to go. (Okay maybe it's a little more complicated than I first thought).


## How does it work?
Through the power of Godot and the useful GDScript interpreted language, the entire source code of the game is readable in the final executable (which is also only one file). In the game, there's 3 ways to take damage: You shoot yourself, you get shot or you get unlucky with pills.

Replacing `CheckAchievement_why()`, which is a method triggered when you shoot yourself, with a same-length `print("player_shot"  )` will just work.
The second occurence is a bit tricky, because searching for `speaker_medicine.play()` will result in 2 occurences. Simply picking the first one and replacing it with `print("player_shot"   )` does the job.. let's just hope there won't be any updates to the game.
Lastly, the second occurence of `smoke.SpawnSmoke("barrel")` is replaced with `print("player_shot"      )` to cover the dealer shooting you.

This will indeed break the achievement for shooting yourself with a sawed-off shotgun, the medicine sound effect and the smoke effect when the dealer shoots you. But does it really matter?

## How do I know it works?
Launching the game and taking damage should shock you. If you're scared of malfunction, check the pishock logs on the website without the shock collar on. If you're still scared... well, you're playing Russian Roulette, what did you expect? (I'd just like to point out, that github copilot suggested that previous sentence)

## Is it tested?
No, lmao.
