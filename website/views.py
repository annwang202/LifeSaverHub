from flask import Blueprint, render_template, request, flash, jsonify, redirect, url_for
from flask_login import login_required, current_user
from .models import Note, Event, EventDate, Trainer, TrainerDate
from . import db
import json
from datetime import datetime
from sqlalchemy import asc

views = Blueprint('views', __name__)
colors = [["pink","#ff80ff"],["red","#fc4242"],["orange","#fca349"],["yellow","#fcde17"],
          ["green","#14f51f"],["light-blue","#81ebf7"],["purple","#4c07fa"],["brown","#7F5D56"],["light-orange","#facdac"],["yellow-green","#d9f78b"],["blue","#0791fa"]]
#trainer_colors = [["black"],["light-brown"],["light-grey"],["dark-grey"],["dark-brown"],["dark-green"],["dark-blue"]]

@views.route('/', methods=['GET', 'POST'])
@login_required
def home():
    events = Event.query.all()
    for event in events:
        if event.dates:
            event.dates.sort(key=lambda date: date.start_date)
    trainers = Trainer.query.all()
    for trainer in trainers:
        if trainer.dates:
            trainer.dates.sort(key=lambda date: date.start_date)
    return render_template("home.html", user=current_user, events=events, trainers = trainers, colors = colors)

@views.route('/trainee', methods=['GET', 'POST'])
@login_required
def trainee():
    events = Event.query.all()
    for event in events:
        if event.dates:
            event.dates.sort(key=lambda date: date.start_date)
    trainers = Trainer.query.all()
    for trainer in trainers:
        if trainer.dates:
            trainer.dates.sort(key=lambda date: date.start_date)
    return render_template("trainee.html", user=current_user, events=events, trainers = trainers, colors = colors)

@views.route('/trainer', methods=['GET', 'POST'])
@login_required
def trainer():
    events = Event.query.all()
    for event in events:
        if event.dates:
            event.dates.sort(key=lambda date: date.start_date)
    trainers = Trainer.query.all()
    for trainer in trainers:
        if trainer.dates:
            trainer.dates.sort(key=lambda date: date.start_date)
    return render_template("trainer.html", user=current_user, events=events, trainers = trainers, colors = colors)

@views.route('/submit-event', methods=['GET', 'POST'])
@login_required
def submit_event():
    if request.method == 'POST':
        if request.form.get("event_form"): #get event form submission
            event_title = request.form["event_title"]
            event_description = request.form["event_description"]
            date_entries = request.form.getlist("date[]")  # Retrieve multiple date entries
            start_times = request.form.getlist("start_time[]")  # Retrieve multiple start times
            end_times = request.form.getlist("end_time[]")  # Retrieve multiple end times
            new_event = Event(title=event_title, description=event_description)
            for date, start_time, end_time in zip(date_entries, start_times, end_times):
                event_date = datetime.strptime(f"{date} {start_time}", "%Y-%m-%d %H:%M")
                end_date = datetime.strptime(f"{date} {end_time}", "%Y-%m-%d %H:%M")
                iso8601_start_date = event_date.isoformat()
                iso8601_end_date = end_date.isoformat()
                formatted_event_date = event_date.strftime('%Y-%m-%d %I:%M %p')
                formatted_end_time = end_date.strftime("%I:%M %p")
                new_event_date = EventDate(
                    start_date=event_date, end_date = end_date, formatted_start_date=formatted_event_date, formatted_end_time = formatted_end_time,iso_formatted_start_date=iso8601_start_date,iso_formatted_end_date=iso8601_end_date)
                new_event.dates.append(new_event_date)
            db.session.add(new_event)  # adding the note to the database
            db.session.commit()
            flash('Event added to list!', category='success')

    return redirect(url_for('views.trainee'))

@views.route('/submit-trainer', methods=['GET', 'POST'])
@login_required
def submit_trainer():
    if request.method == 'POST':
        if request.form.get("trainer_form"): #get training availability form submission
            trainer_name = request.form["trainer_name"]
            other_info = request.form["other_info"]
            date_entries = request.form.getlist("date[]")  # Retrieve multiple date entries
            start_times = request.form.getlist("start_time[]")  # Retrieve multiple start times
            end_times = request.form.getlist("end_time[]")  # Retrieve multiple end times
            new_trainer = Trainer(name=trainer_name, other_info=other_info)
            for date, start_time, end_time in zip(date_entries, start_times, end_times):
                trainer_date = datetime.strptime(f"{date} {start_time}", "%Y-%m-%d %H:%M")
                end_date = datetime.strptime(f"{date} {end_time}", "%Y-%m-%d %H:%M")
                iso8601_start_date = trainer_date.isoformat()
                iso8601_end_date = end_date.isoformat()
                formatted_trainer_date = trainer_date.strftime('%Y-%m-%d %I:%M %p')
                formatted_end_time = end_date.strftime("%I:%M %p")
                new_trainer_date = TrainerDate(
                    start_date=trainer_date, end_date = end_date, formatted_start_date=formatted_trainer_date, formatted_end_time = formatted_end_time,iso_formatted_start_date=iso8601_start_date,iso_formatted_end_date=iso8601_end_date)
                new_trainer.dates.append(new_trainer_date)
            db.session.add(new_trainer)  # adding the note to the database
            db.session.commit()
            flash('Trainer added to list!', category='success')
    return redirect(url_for('views.trainer'))

#@views.route('/delete-note', methods=['POST'])
#def delete_note():
    # this function expects a JSON from the INDEX.js file
 #   note = json.loads(request.data)
  #  noteId = note['noteId']
   # note = Note.query.get(noteId)
    #if note:
     #   if note.user_id == current_user.id:
      #      db.session.delete(note)
       #     db.session.commit()

   # return jsonify({})


@views.route('/delete-event', methods=['POST'])
def delete_event():
    # this function expects a JSON from the INDEX.js file
    event = json.loads(request.data)
    eventId = event['eventId']
    event = Event.query.get(eventId)
    if event:
        db.session.delete(event)
        db.session.commit()
    return jsonify({})


@views.route('/eventdata')
def event_mysql_to_json():
    # Assuming you have a SQLAlchemy model for the table you want to export
    # Replace 'YourModel' with the actual name of your SQLAlchemy model
    from .models import User, Note, Event, EventDate

    # Query the data from the database
    data = Event.query.all()

    # Convert the data to a list of dictionaries
    sources_list = []
    for event in data:
        event_list = []
        for slot in event.dates:
            time_dict = {
                'id': slot.id,
                'title': event.title,
                'start': slot.iso_formatted_start_date,
                'end': slot.iso_formatted_end_date,
                'eventDisplay':'background',
                'display':'block',
                'displayEventEnd': True,
                'color': colors[(event.id - 1) % len(colors)][1],
                'extendedProps': {
                    'trainerTrue': False,
                    'description': event.description,
                    'formattedStartDate': slot.formatted_start_date,
                    'formattedEndTime': slot.formatted_end_time,
                    'eventId':event.id
                }
                # Add other attributes here as needed
            }
            event_list.append(time_dict)
        event_dict = {'events':event_list,'id':event.id}
        sources_list.append(event_dict)

    # Convert the data to JSON
    json_data = jsonify(sources_list).get_data(as_text=True)

    # Save the JSON data to a file (optional)
    with open('event_mysql_data.json', 'w') as json_file:
        json_file.write(json_data)

    return json_data

@views.route('/trainerdata')
def trainer_mysql_to_json():
    # Assuming you have a SQLAlchemy model for the table you want to export
    # Replace 'YourModel' with the actual name of your SQLAlchemy model
    from .models import User, Note, Trainer, TrainerDate

    # Query the data from the database
    data = Trainer.query.all()

    # Convert the data to a list of dictionaries
    sources_list = []
    for trainer in data:
        event_list = []
        for slot in trainer.dates:
            time_dict = {
                'id': slot.id,
                'title': trainer.name,
                'start': slot.iso_formatted_start_date,
                #'end': slot.iso_formatted_end_date,
                'color': colors[(len(colors) - 1) - ((trainer.id - 1) % len(colors))][1],
                'extendedProps': {
                    'trainerTrue': True,
                    'description': trainer.other_info,
                    'formattedStartDate': slot.formatted_start_date,
                    'formattedEndTime': slot.formatted_end_time,
                    'trainerId':trainer.id
                }
                # Add other attributes here as needed
            }
            event_list.append(time_dict)
        trainer_dict = {'events':event_list,'id':trainer.id}
        sources_list.append(trainer_dict)

    # Convert the data to JSON
    json_data = jsonify(sources_list).get_data(as_text=True)

    # Save the JSON data to a file (optional)
    with open('trainer_mysql_data.json', 'w') as json_file:
        json_file.write(json_data)

    return json_data
