{% assign data = include.data %}

<ul>
{% for material in data.daily %}
<li style=" margin-bottom: 10px;">{{ material.name }}: {{ material.covered }}
    {% if material.due %}
        <br><b>due: {{ material.due }}</b>
    {% endif %}
    {% if material.more %}
        <br>{{ material.more }}
    {% endif %}
    {% if material.chapter %}
        <br>(Chapter {{ material.chapter }})
    {% endif %}
    {% if material.chapters %}
        <br>(Chapters {{ material.chapters }})
    {% endif %}
    {% if material.handout %}
        <br>handout: <a href="{{ data.home }}/{{ material.handout }}">{{ material.handoutname }} (PDF)</a>
    {% endif %}
    {% if material.otherurl %}
        <br><a href="{{ material.otherurl }}">{{ material.otherurlname }}</a>
    {% endif %}
</li>
{% endfor %}
</ul>
