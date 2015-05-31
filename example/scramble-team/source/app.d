import std.stdio;
import std.conv : to;

import mjtournament.tournament;

void main(string[] args)
{
	immutable duplication = (2 < args.length)?
		args[2].to!size_t:
		1;
	foreach (line; stdin.byLine)
	{
		auto tournament = line.to!string.toTournament;
		foreach (i; 0..duplication)
			"%l".writefln(tournament.scramble(args[1].to!size_t));
	}
}
