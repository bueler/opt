{% assign data = include.data %}
<table class="asst-table">
{% for ws in data.worksheets %}
<tr>
	<td>{{ ws.name }}</td>
	<td>
		<table class="inner">
			{% if ws.description %}
			<tr>
			    <td>{{ ws.description }}</td>
			</tr>
			{% endif %}
			{% if ws.blank %}
					{% if ws.solutions %}
					<tr>
					    <td><a href="{{ data.home }}/{{ ws.blank }}">blank</a> &nbsp; &nbsp; <a href="{{ data.home }}/{{ ws.solutions }}">solutions</a></td>
					</tr>
					{% else %}
				  <tr>
					    <td><a href="{{ data.home }}/{{ ws.blank }}">blank</a></td>
					</tr>
					{% endif %}
			{% endif %}
			{% if ws.mfile %}
			<tr>
			    <td><a href="{{ data.home }}/{{ ws.mfile }}">{{ ws.mfile }}</a> (Matlab demo)</td>
			</tr>
			{% endif %}
		</table>
		<div style="padding-bottom: 10px"></div>
	</td>
</tr>
{% endfor %}
</table>
