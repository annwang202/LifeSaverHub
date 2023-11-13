from flask import Blueprint, render_template, request, flash, jsonify, redirect, url_for
from flask_login import login_required, current_user
from .models import Event, EventDate, Trainer, TrainerDate
from . import db
import json
from datetime import datetime
from sqlalchemy import asc
from werkzeug.utils import secure_filename

views = Blueprint('views', __name__)
black = "#000000"
white = "#FFFFFF"
event_colors = [["#f7c95e",black],["#ffa04c",black],["#ff724f",white],["#f34e57",white],["#c8006f",white],["#7d0085",white],["#41008c",white],["#250250",white],["#f0d4fa",black]]
trainer_colors = [["#044080",white],["#0889d4",white],["#8dcbd9",white],["#5bde81",white],["#018a78",white],["#daf763",black],["#e8e15f",black],["#fab852",black],["#fa6464",black]]

@views.route('/', methods=['GET', 'POST'])
@login_required
def home():
    events = Event.query.all()
    for event in events:
        if event.backup_dates:
            event.backup_dates.sort(key=lambda date: date.start_date)
    trainers = Trainer.query.all()
    '''
    for trainer in trainers:
        if trainer.gen_avail:
            trainer.gen_avail.sort(key=lambda date: date.start_date)
    '''
    return render_template("home.html", user=current_user, events=events, trainers = trainers, event_colors = event_colors,trainer_colors=trainer_colors)

@views.route('/trainee', methods=['GET', 'POST'])
@login_required
def trainee():
    return render_template("trainee.html", user=current_user)

@views.route('/trainer', methods=['GET', 'POST'])
@login_required
def trainer():
    return render_template("trainer.html", user=current_user, trainer_colors=trainer_colors)

@views.route('/trainer_info', methods=['GET', 'POST'])
@login_required
def trainer_info():
    trainers = Trainer.query.all()
    '''
    for trainer in trainers:
        if trainer.gen_avail:
            trainer.gen_avail.sort(key=lambda date: date.start_date)
    '''
    return render_template("trainer_info.html", user=current_user, trainers = trainers,trainer_colors=trainer_colors)


@views.route('/submit-event', methods=['GET', 'POST'])
@login_required
def submit_event():
    if request.method == 'POST':
        if request.form.get("event_form"): #get event form submission
            name = request.form["event_name"]
            email = request.form["event_email"]
            phone = request.form["event_phone"]
            title = request.form["event_title"]
            training_types = request.form.getlist('training_type[]')
            training_types_string = ', '.join(training_types)
            preferred_date = request.form.getlist("date")
            preferred_start = request.form.getlist("start_time")
            preferred_end = request.form.getlist("end_time")
            backup_dates = request.form.getlist("date[]")  # Retrieve multiple date entries
            backup_starts = request.form.getlist("start_time[]")  # Retrieve multiple start times
            backup_ends = request.form.getlist("end_time[]")  # Retrieve multiple end times
            mission = request.form.get("event_mission")
            learners = request.form.get("event_learners")
            place = request.form.get("event_place")
            chairs_tables = request.form.get("event_chairs_tables")
            cultural = request.form.get("event_cultural")
            content_concerns = request.form.get("event_content_concerns")
            music = request.form.get("event_music")
            photos = request.form.get("event_photos")
            other_info = request.form.get("event_other_info")
            status = "New"
            new_event = Event(name=name,email=email,phone=phone,title=title, training_types=training_types_string,
                              mission=mission,learners=learners,place=place,chairs_tables=chairs_tables,cultural=cultural,
                              content_concerns=content_concerns,music=music,photos=photos,other_info=other_info,status=status)
            backup_eventDates = create_event_dates(backup_dates,backup_starts,backup_ends)
            for eventDate in backup_eventDates:
                new_event.backup_dates.append(eventDate)
            preferred_eventDates = create_event_dates(preferred_date,preferred_start,preferred_end)
            new_event.preferred_date.append(preferred_eventDates[0])
            db.session.add(new_event)  # adding the event to the database
            db.session.commit()
            flash('Event added to list!', category='success')

    return redirect(url_for('views.trainee'))

@views.route('/submit-trainer', methods=['GET', 'POST'])
@login_required
def submit_trainer():
    if request.method == 'POST':
        if request.form.get("trainer_form"): #get training availability form submission
            trainer_name = request.form["trainer_name"]
            trainer_nickname = request.form["trainer_nickname"]
            trainer_bd = request.form["trainer_bd"]
            bd_date = datetime.strptime(trainer_bd, '%Y-%m-%d').date()
            trainer_pronouns = request.form["trainer_pronouns"]
            trainer_race = request.form["trainer_race"]
            how_did_you_hear = request.form["how_did_you_hear"]
            trainer_phone = request.form["trainer_phone"]
            text_or_call = request.form["text_or_call"]
            trainer_email = request.form["trainer_email"]
            trainer_education = request.form["trainer_education"]
            ls_skills_background = request.form.getlist("ls_skills_background[]")
            ls_skills_background_string = ', '.join(ls_skills_background)
            relevant_experience = request.form["relevant_experience"]
            get_heartsaver_instructor_interest = request.form.get('heartsaver_instructor_interest')
            if get_heartsaver_instructor_interest == 'on':
                heartsaver_instructor_interest = 'Yes'
            else:
                heartsaver_instructor_interest = 'No'
            trainer_availability = request.form["trainer_availability"]
            '''
            date_entries = request.form.getlist("date[]")  # Retrieve multiple date entries
            start_times = request.form.getlist("start_time[]")  # Retrieve multiple start times
            end_times = request.form.getlist("end_time[]")  # Retrieve multiple end times
            '''
            preferred_hrs_per_month = request.form["preferred_hrs_per_month"]
            trainer_languages = request.form["trainer_languages"]
            other_info = request.form["other_info"]
            '''
            docs = request.files.getlist('trainer_docs[]')
            for file in docs:
                if file:
                    filename = secure_filename(file.filename)
                    file.save(os.path.join(app.config['UPLOAD_FOLDER'],filename))
            '''
            new_trainer = Trainer(name=trainer_name, nickname=trainer_nickname,date_of_birth=bd_date,pronouns=trainer_pronouns,
                                  race_ethnicity=trainer_race,how_did_you_hear=how_did_you_hear,
                                  phone=trainer_phone,text_or_call=text_or_call,email=trainer_email,education=trainer_education,
                                  lifesaver_skills=ls_skills_background_string,relevant_exp=relevant_experience,
                                  heartsaver_interest=heartsaver_instructor_interest,gen_avail=trainer_availability,hrs_per_month=preferred_hrs_per_month,
                                  languages=trainer_languages,other_info=other_info,status="New")
            '''
            for date, start_time, end_time in zip(date_entries, start_times, end_times):
                trainer_date = datetime.strptime(f"{date} {start_time}", "%Y-%m-%d %H:%M")
                end_date = datetime.strptime(f"{date} {end_time}", "%Y-%m-%d %H:%M")
                iso8601_start_date = trainer_date.isoformat()
                iso8601_end_date = end_date.isoformat()
                formatted_trainer_date = trainer_date.strftime('%Y-%m-%d %I:%M %p')
                formatted_end_time = end_date.strftime("%I:%M %p")
                new_trainer_date = TrainerDate(
                    start_date=trainer_date, end_date = end_date, formatted_start_date=formatted_trainer_date, formatted_end_time = formatted_end_time,iso_formatted_start_date=iso8601_start_date,iso_formatted_end_date=iso8601_end_date)
                new_trainer.gen_avail.append(new_trainer_date)
            '''
            db.session.add(new_trainer)  # adding the note to the database
            db.session.commit()
            flash('Trainer added to list!', category='success')
    return redirect(url_for('views.trainer'))

@views.route('/update-event', methods=['GET', 'POST'])
@login_required
def update_event():
    if request.method == 'POST':
        if request.form.get("update_form"): #get event form submission
            update_id = request.form.get('update_id')
            new_status = request.form.get('status')
            event = Event.query.get(update_id)
            if event:
                # Update the event status
                event.status = new_status
                db.session.commit()
                flash('Event updated!', category='success')
            else:
                flash('Event not found or could not be updated.', category='error')
    return redirect(url_for('views.home'))

@views.route('/update-trainer', methods=['GET', 'POST'])
@login_required
def update_trainer():
    if request.method == 'POST':
        if request.form.get("update_trainer_form"): #get event form submission
            update_id = request.form.get('update_id')
            new_status = request.form.get('status')
            trainer = Trainer.query.get(update_id)
            if trainer:
                # Update the event status
                trainer.status = new_status
                db.session.commit()
                flash('Trainer updated!', category='success')
            else:
                flash('Trainer not found or could not be updated.', category='error')
    return redirect(url_for('views.trainer_info'))

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
    from .models import User, Event, EventDate

    # Query the data from the database
    data = Event.query.all()

    # Convert the data to a list of dictionaries
    sources_list = []
    for event in data:
        event_list = []
        for slot in (event.backup_dates + event.preferred_date):
            time_dict = {
                'id': slot.id,
                'title': event.title,
                'start': slot.iso_formatted_start_date,
                'end': slot.iso_formatted_end_date,
                'eventDisplay':'background',
                'display':'block',
                'displayEventEnd': True,
                'color': event_colors[(event.id - 1) % len(event_colors)][0],
                'eventTextColor':event_colors[(event.id - 1) % len(event_colors)][1],
                'extendedProps': {
                    'trainerTrue': False,
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

'''
@views.route('/trainerdata')
def trainer_mysql_to_json():
    # Assuming you have a SQLAlchemy model for the table you want to export
    # Replace 'YourModel' with the actual name of your SQLAlchemy model
    from .models import User, Trainer, TrainerDate

    # Query the data from the database
    data = Trainer.query.all()

    # Convert the data to a list of dictionaries
    sources_list = []
    for trainer in data:
        event_list = []
        for slot in trainer.gen_avail:
            time_dict = {
                'id': slot.id,
                'title': trainer.name,
                'start': slot.iso_formatted_start_date,
                'end': slot.iso_formatted_end_date,
                'displayEventEnd': True,
                'color': trainer_colors[(trainer.id - 1) % len(trainer_colors)][0],
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
'''
############
'''
@views.route('/icsfinalcalendar')
def create_ics():
    from .models import User, Event, EventDate,Trainer,TrainerDate

    # Query the data from the database
    event_data = Event.query.all()
    trainer_data = Trainer.query.all()

    ics_content = "BEGIN:VCALENDAR\n"
    for event in event_data:
        if (event.status=="Scheduled"):
            for slot in event.dates:
                ics_content += "BEGIN:VEVENT\n"
                ics_content += f"DTSTART:{slot.iso_formatted_start_date}\n"
                ics_content += f"DTEND:{slot.iso_formatted_end_date}\n"
                ics_content += f"SUMMARY:{event.title}\n"
                ics_content += f"DESCRIPTION:{event.description}\n"
                ics_content += "END:VEVENT\n"
    for trainer in trainer_data:
        if (trainer.status == "Scheduled"):
            for slot in trainer.gen_avail:
                ics_content += "BEGIN:VEVENT\n"
                ics_content += f"DTSTART:{slot.iso_formatted_start_date}\n"
                ics_content += f"DTEND:{slot.iso_formatted_end_date}\n"
                ics_content += f"SUMMARY:{trainer.name}\n"
                ics_content += f"DESCRIPTION:{trainer.other_info}\n"
                ics_content += "END:VEVENT\n"
    ics_content += "END:VCALENDAR"

# Save to a .ics file
    with open("scheduled_events.ics", "w") as ics_file:
        ics_file.write(ics_content)
    return ics_file
'''
####
def create_event_dates(dates,starts,ends):
    event_dates = []
    for date, start_time, end_time in zip(dates, starts, ends):
        event_date = datetime.strptime(f"{date} {start_time}", "%Y-%m-%d %H:%M")
        end_date = datetime.strptime(f"{date} {end_time}", "%Y-%m-%d %H:%M")
        iso8601_start_date = event_date.isoformat()
        iso8601_end_date = end_date.isoformat()
        formatted_event_date = event_date.strftime('%m/%d/%Y %I:%M %p')
        formatted_end_time = end_date.strftime("%I:%M %p")
        new_event_date = EventDate(
        start_date=event_date, end_date = end_date, formatted_start_date=formatted_event_date, formatted_end_time = formatted_end_time,iso_formatted_start_date=iso8601_start_date,iso_formatted_end_date=iso8601_end_date)
        event_dates.append(new_event_date)
    return event_dates
