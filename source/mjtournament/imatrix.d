module mjtournament.imatrix;
import mjtournament.tournament;

alias IMatrix = size_t[][];

IMatrix rowsToTeam(IMatrix im, size_t teamSize = playerPerTable)
{
	assert (im.length % teamSize == 0);
	immutable teams = im.length / teamSize;
	foreach (i; 0..teams)
		foreach (j; 1..teamSize)
			im[i * teamSize][] += im[i * teamSize + j][];
	foreach (i; 0..teams)
		im = im[0..i+1] ~ im[i+teamSize..$];
	return im;
}

IMatrix colsToTeam(IMatrix im, size_t teamSize = playerPerTable)
{
	return im.transpose.rowsToTeam(teamSize).transpose;
}

IMatrix bothToTeam(IMatrix im, size_t teamSize = playerPerTable)
{
	return im.rowsToTeam.transpose.rowsToTeam;
}

private auto transpose(IMatrix im)
{
	auto ret = new IMatrix(im[0].length, im.length);
	foreach (i, row; im)
		foreach (j, elem; row)
			ret[j][i] = elem;
	return ret;
}
