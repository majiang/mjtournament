import std.stdio;

import mjtournament.tournament, mjtournament.imatrix;
import std.algorithm : map, reduce;
import std.conv : to;
import std.array;

import std.string;
void main(string[] args)
{
	auto cdcs = args[1..$].map!(to!size_t).array.cumsum;
	foreach (line; stdin.byLine)
		line.strip.writeln(",", line.to!string.getColorDist(cdcs));
}

auto getColorDist(string line, size_t[] cdcs)
{
	auto tournament = line.toTournament;
	immutable teamSize = cdcs.length - 2;
	auto cd = new size_t[][] (tournament.rounds, tournament.tables);
	foreach (p, player; tournament.assignment)
	{
		immutable
			i = p / teamSize, // index of team
			j = p % teamSize; // index in team
		foreach (k, x; cdcs)
		{
			if (x <= i)
				continue;
			foreach (r, table; player)
				cd[r][table] += j < (k-1);
			break;
		}
	}
	ulong sum;
	foreach (row; cd)
		foreach (elem; row)
			sum += [0, 3, 4, 3, 0][elem];
	return sum;
}

private T[] cumsum(T)(T[] x)
{
	foreach (i; 1..x.length)
		x[i] += x[i-1];
	return 0 ~ x;
}
