from flask import render_template, request, redirect
from . import db
from .models import Todo
from flask import current_app as app

@app.route('/', methods=['GET', 'POST'])
def index():
    if request.method == 'POST':
        task = request.form['task']
        if task:
            new_task = Todo(task=task)
            db.session.add(new_task)
            db.session.commit()
        return redirect('/')
    
    todos = Todo.query.all()
    return render_template('index.html', todos=todos)
