# Release Process

In this example, we will tag version 1.2.3-4

## Ensure Clean Repo

<table
	cellpadding=0
	cellspacing=2
	border
>

<tr><th>git</th><th>svn</th></tr>
<tr>
	<td valign=top align=left><pre>git status</pre></td>
	<td valign=top align=left><pre>svn status</pre></td>
</tr>
</table>


## Bump Changelog
<table
	cellpadding=0
	cellspacing=2
	border
>

<tr><td colspan=2><pre>vi ias-project-name/changelog</pre><br>
The date is:<pre>date -R</pre></td></tr>
<tr><th>git</th><th>svn</th></tr>
<tr>
	<td valign=top align=left><pre>git add ias-project-name/changelog
git commit -m 'bumped changelog'</pre></td>
	<td valign=top align=left><pre>svn commit -m 'bumped changelog'</pre></td>
</tr>
</table>

## Tag

<table
	cellpadding=0
	cellspacing=2
	border
>

<tr><th>git</th><th>svn</th></tr>
<tr>
	<td valign=top align=left><pre>git tag -a v1.2.3-4
git push origin v1.2.3-4</pre></td>
	<td valign=top align=left><pre>svn cp https://svn.ias.edu/repos/network/applications/ias_project_name/ \
https://svn.ias.edu/repos/network/tags/applications/ias_project_name/ias_project_name-1.2.3-4/</pre></td>
</tr>
</table>


<!--
Blank row:
<tr>
	<td valign=top align=left><pre></pre></td>
	<td valign=top align=left><pre></pre></td>
</tr>

-->
