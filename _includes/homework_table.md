{% assign data = include.data %}
<table class="asst-table">
{% for hw in data.homework %}
<tr>
	<td>
		<table class="inner">
		  <tr>
        <td><a href="{{ data.home }}/{{ hw.blank }}">{{ hw.name }} (PDF)</a></td>
			</tr>
		  <tr>
        <td>due {{ hw.due }}</td>
			</tr>
		  {% if hw.sections %}
			  <tr>
 		      <td>sections to read: {{ hw.sections }}</td>
				</tr>
		  {% endif %}
		  {% if hw.seealsopdf %}
			  <tr>
          <td>see also: <a href="{{ hw.seealsopdf }}">{{ hw.seealsoname }} (PDF)</a></td>
				</tr>
		  {% endif %}
		</table>
	</td>
</tr>
{% endfor %}
</table>
