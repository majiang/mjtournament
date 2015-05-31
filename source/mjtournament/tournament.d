module mjtournament.tournament;

enum size_t playerPerTable = 4;
import std.algorithm, std.range, std.array, std.string, std.format, std.conv, std.random;

struct Tournament
{
	immutable size_t tables, players, rounds;
	size_t[][] assignment;
	pure this (in size_t tables, in size_t players, in size_t rounds)
	{
		this.tables = tables;
		this.players = players;
		this.rounds = rounds;
		this.assignment = new size_t[][] (players, rounds);
	}
	size_t[][] incidenceMatrix()
	{
		auto ret = new size_t[][] (players, players);
		foreach (i, p; assignment)
			foreach (j, q; assignment)
				if (i == j)
					break;
				else
					foreach (r; 0..rounds)
						ret[j][i] = ret[i][j] += p[r] == q[r] && p[r] < tables;
		return ret;
	}
	void toString(scope void delegate(const(char)[]) sink,
		FormatSpec!char fs) const
	{
		switch (fs.spec)
		{
			case 's', 'p': // default (player-centered) format
				foreach (player; assignment)
					sink("%(%d %)\n".format(player));
				break;
			case 't': // table-centered format
				foreach (round; 0..rounds)
				{
					foreach (table; 0..tables)
						sink("%(%d %)\n".format(players.iota.filter!(player => assignment[player][round] == table)));
					if (round + 1 < rounds)
						sink("\n");
				}
				break;
			case 'l': // one-liner format
				sink("%d %d %d".format(tables, players, rounds));
				foreach (round; 0..rounds)
					foreach (player; 0..players)
						sink(" %d".format(assignment[player][round]));
				break;
			default:
				throw new Exception("Unknown format specifier: %" ~ fs.spec);
		}
	}
}

pure Tournament skipRounds(Tournament tournament, size_t skip)
in
{
	assert (skip <= tournament.rounds);
}
body
{
	auto ret = Tournament(tournament.tables, tournament.players, tournament.rounds - skip);
	ret.assignment = tournament.assignment.map!(a => a[skip..$]).array;
	return ret;
}


Tournament scramble(in Tournament tournament, in size_t teamSize)
{
	assert (tournament.players % teamSize == 0);
	auto teams = tournament.players / teamSize;
	auto ret = Tournament(tournament.tables, tournament.players, tournament.rounds);
	size_t p;
	foreach (team; teams.iota.randomCover)
		foreach (idx; teamSize.iota.randomCover)
			ret.assignment[p++] = tournament.assignment[team * teamSize + idx].dup;
	return ret;
}

Tournament scrambleTables(Tournament tournament)
{
	auto ret = Tournament(tournament.tables, tournament.players, tournament.rounds);
	assert (false);
}

/** Read a tournament from one-liner string.

Input line must be a sequence of non-negative integers separated by white spaces, which start with numbers of tables, players, and rounds.
The following (players * rounds) numbers are interpreted as the tables at which players play in the rounds of the tournament.

example:
toTournament("1 5 5 [1 0 0 0 0] [0 1 0 0 0] [0 0 1 0 0] [0 0 0 1 0] [0 0 0 0 1]") (brackets for explanation)
is a trivial tournament played by one table with 5 players.
Each section in the brackets is a round, each element of which is the number of the table each player plays at.

*/
pure Tournament toTournament(string x)
{
	auto buf = x.strip.split(",")[0].split.map!(to!size_t);
	auto tournament = Tournament(buf[0], buf[1], buf[2]);
	buf = buf[3..$];
	foreach (round; 0..tournament.rounds)
		foreach (player; 0..tournament.players)
		{
			tournament.assignment[player][round] = buf.front;
			buf.popFront;
		}
	return tournament;
}

/** Read a tournament from a string array.

Each line corresponds to a player and is indicating the tables at which the player plays in the rounds.
*/
pure Tournament toTournament(string[] x)
{
	x = x.filter!(e => e.length).array;
	immutable
		players = x.length,
		tables = players / playerPerTable;
	auto buf = x.map!(e => e.strip.split.map!(to!size_t).array).array;
	immutable rounds = buf[0].length;
	auto tournament = Tournament(tables, players, rounds);
	foreach (player, assignment; buf)
		foreach (round, table; assignment)
			tournament.assignment[player][round] = table;
	return tournament;
}




