import std.stdio;
import std.conv : to;
import std.algorithm : map;
import std.array : array;

import mjtournament.tournament;

void main(string[] args)
{
	stderr.writeln("usage:
    oneliner [skipRounds] < player-centered.ssv > one-liner.ssv");
	size_t skip;
	if (1 < args.length)
		skip = args[1].to!size_t;
	writefln("%l", stdin.byLine.map!(to!string).array.toTournament.skipRounds(skip));
}
