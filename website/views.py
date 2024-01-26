from flask import Blueprint, render_template, request, flash, jsonify, redirect, url_for
from flask_login import login_required, current_user
from .models import Event, EventDate, Trainer, TrainerDate, Assignment,assignment_event_association,assignment_trainer_association
from . import db
import json
from datetime import datetime
from sqlalchemy import asc
from werkzeug.utils import secure_filename
import re
from sqlalchemy.orm import joinedload

views = Blueprint('views', __name__)
black = "#000000"
white = "#FFFFFF"
event_colors = [["#f7c95e", black], ["#ffa04c", black], ["#ff724f", white], ["#f34e57", white], [
    "#c8006f", white], ["#7d0085", white], ["#41008c", white], ["#250250", white], ["#f0d4fa", black]]
trainer_colors = [["#044080", white], ["#0889d4", white], ["#8dcbd9", white], ["#5bde81", white], [
    "#018a78", white], ["#daf763", black], ["#e8e15f", black], ["#fab852", black], ["#fa6464", black]]


@views.route('/', methods=['GET', 'POST'])
@login_required
def home():
    assignments = []
    events = (
        Event.query
        .join(Event.preferred_date).order_by(EventDate.start_date)
    )
    for event in events:
        if event.backup_dates:
            event.backup_dates.sort(key=lambda date: date.start_date)
        assignments.append(Assignment.query
            .join(assignment_event_association)  # Join the association table
            .join(Event)  # Join the Event model
            .join(assignment_trainer_association)
            .join(Trainer)
            .filter(Event.id == event.id)  # Filter by the specific event request
            .options(joinedload(Assignment.trainer))  # Optionally load the associated trainers
            .all())
    trainers = Trainer.query.all()
    '''
    assignments = Assignment.query.options(
        joinedload(Assignment.event_request)).all()
    for trainer in trainers:
        if trainer.gen_avail:
            trainer.gen_avail.sort(key=lambda date: date.start_date)
    '''
    trainers_data = [{'id': trainer.id, 'name': trainer.name,
                      'gen_avail': trainer.gen_avail} for trainer in trainers]
    return render_template("home.html", user=current_user, events=events, trainers=trainers, assignments=assignments, trainers_data=trainers_data, event_colors=event_colors, trainer_colors=trainer_colors)


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
    # trainers_data = [{'id': trainer.id, 'name': trainer.name, 'gen_avail': trainer.gen_avail} for trainer in trainers]
    trainers_data = []
    for trainer in trainers:
        trainers_data.append(trainer.name)
    return render_template("trainer_info.html", user=current_user, trainers=trainers, trainers_data=trainers_data, trainer_colors=trainer_colors)


@views.route('/submit-event', methods=['GET', 'POST'])
@login_required
def submit_event():
    if request.method == 'POST':
        if request.form.get("event_form"):  # get event form submission
            name = request.form["event_name"]
            email = request.form["event_email"]
            phone = request.form["event_phone"]
            title = request.form["event_title"]
            training_types = request.form.getlist('training_type[]')
            training_types_string = ', '.join(training_types)
            preferred_date = request.form.getlist("date")
            preferred_start = request.form.getlist("start_time")
            preferred_end = request.form.getlist("end_time")
            backup_dates = request.form.getlist(
                "date[]")  # Retrieve multiple date entries
            backup_starts = request.form.getlist(
                "start_time[]")  # Retrieve multiple start times
            backup_ends = request.form.getlist(
                "end_time[]")  # Retrieve multiple end times
            mission = request.form.get("event_mission")
            num_learners = request.form.get("num_learners")
            learners = request.form.get("event_learners")
            place = request.form.get("event_place")
            chairs_tables = request.form.get("event_chairs_tables")
            cultural = request.form.get("event_cultural")
            content_concerns = request.form.get("event_content_concerns")
            music = request.form.get("event_music")
            photos = request.form.get("event_photos")
            other_info = request.form.get("event_other_info")
            status = "New"
            new_event = Event(name=name, email=email, phone=phone, title=title, training_types=training_types_string,
                              mission=mission, num_learners=num_learners,learners=learners, place=place, chairs_tables=chairs_tables, cultural=cultural,
                              content_concerns=content_concerns, music=music, photos=photos, other_info=other_info, status=status)
            if backup_dates[0] and backup_starts[0] and backup_ends[0]:
                backup_eventDates = create_event_dates(
                    backup_dates, backup_starts, backup_ends)
                for eventDate in backup_eventDates:
                    new_event.backup_dates.append(eventDate)
            preferred_eventDates = create_event_dates(
                preferred_date, preferred_start, preferred_end)
            new_event.preferred_date.append(preferred_eventDates[0])
            db.session.add(new_event)  # adding the event to the database
            db.session.commit()
            flash('Event added to list!', category='success')

    return redirect(url_for('views.trainee'))


@views.route('/submit-trainer', methods=['GET', 'POST'])
@login_required
def submit_trainer():
    if request.method == 'POST':
        # get training availability form submission
        if request.form.get("trainer_form"):
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
            ls_skills_background = request.form.getlist(
                "ls_skills_background[]")
            ls_skills_background_string = ', '.join(ls_skills_background)
            relevant_experience = request.form["relevant_experience"]
            get_heartsaver_instructor_interest = request.form.get(
                'heartsaver_instructor_interest')
            if get_heartsaver_instructor_interest:
                if get_heartsaver_instructor_interest.lower() == 'on':
                    heartsaver_instructor_interest = 'Yes'
            else:
                heartsaver_instructor_interest = 'No'
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
            new_trainer = Trainer(name=trainer_name, nickname=trainer_nickname, date_of_birth=bd_date, pronouns=trainer_pronouns,
                                  race_ethnicity=trainer_race, how_did_you_hear=how_did_you_hear,
                                  phone=trainer_phone, text_or_call=text_or_call, email=trainer_email, education=trainer_education,
                                  lifesaver_skills=ls_skills_background_string, relevant_exp=relevant_experience,
                                  heartsaver_interest=heartsaver_instructor_interest, hrs_per_month=preferred_hrs_per_month,
                                  languages=trainer_languages, other_info=other_info, status="New")
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


@views.route('/submit-assignment', methods=['GET', 'POST'])
@login_required
def submit_assignment():
    if request.method == 'POST':
        try:
            print("Ok lets go")
            # get training availability form submission
            if request.form.get("create-assignment"):
                print("form gotten")
                event_id = request.form["assignment-event-id"]
                start_date = datetime.fromisoformat(
                    request.form["assignment-start-date"])
                end_date = datetime.fromisoformat(
                    request.form["assignment-end-date"])
                formatted_start_date = request.form["assignment-formatted-start-date"]
                formatted_end_time = request.form["assignment-formatted-end-time"]
                trainer_name_and_emails = request.form.getlist(
                    "trainer-slot[]")
                event = Event.query.get(event_id)
                for trainer in trainer_name_and_emails:
                    # Split by spaces and parentheses
                    if (trainer):
                        split = re.split(r'\s\(|\)', trainer)

                        # Remove empty strings from the result
                        result = list(filter(None, split))
                        if(len(result)<2):
                            flash('Trainer ' + trainer + ' not found!', category='error')
                            continue
                        trainer_name = result[0]
                        trainer_email = result[1]
                        print(trainer_name)
                        print(trainer_email)
                        cur_trainer = Trainer.query.filter(
                            Trainer.nickname == trainer_name, Trainer.email == trainer_email).first()
                        if (not cur_trainer):
                            continue
                        print(cur_trainer)
                        event.status = "Tentative" #only change event status to Tentative if there is a trainer to assign to it
                        new_assignment = Assignment(start_date=start_date,
                                                    end_date=end_date,
                                                    formatted_start_date=formatted_start_date,
                                                    formatted_end_time=formatted_end_time,
                                                    trainer_role=cur_trainer.status)
                        new_assignment.event_request.append(event)
                        new_assignment.trainer.append(cur_trainer)
                        # adding the note to the database
                        db.session.add(new_assignment)
                        print(new_assignment)
                db.session.commit()
        except Exception as e:
            print(f"An error occurred: {e}")
            db.session.rollback()  # Rollback the transaction in case of an error
    return redirect(url_for('views.home'))


@views.route('/update-event', methods=['GET', 'POST'])
@login_required
def update_event():
    if request.method == 'POST':
        if request.form.get("update_form"):  # get event form submission
            update_id = request.form.get('update_id')
            new_status = request.form.get('status')
            new_admin_notes= request.form.get('admin_event_notes')
            event = Event.query.get(update_id)
            if event:
                # Update the event status
                event.status = new_status
                event.admin_notes = new_admin_notes
                db.session.commit()
                flash('Event updated!', category='success')
            else:
                flash('Event not found or could not be updated.', category='error')
    return redirect(url_for('views.home'))


@views.route('/update-trainer', methods=['GET', 'POST'])
@login_required
def update_trainer():
    if request.method == 'POST':
            if request.form.get("update_trainer_form"):  # get event form submission
                update_id = request.form.get('update_id')
                new_status = request.form.get('status')
                new_admin_notes= request.form.get('admin_trainer_notes')
                trainer = Trainer.query.get(update_id)
                if trainer:
                    # Update the event status
                    trainer.status = new_status
                    trainer.admin_notes = new_admin_notes
                    db.session.commit()
                    flash('Trainer updated!', category='success')
                else:
                    flash('Trainer not found or could not be updated.', category='error')
    return redirect(url_for('views.trainer_info'))

@views.route('/update-assignment', methods=['GET', 'POST'])
@login_required
def update_assignment():
    print("trying to update assignment")
    if request.method == 'POST':
        try:
            if request.form.get("update-assignment"):  # get event form submission
                event_id = request.form.get('update-assignment-event-id')
                print("event_id: " + event_id)
                new_status = request.form.get('update_assignment_status')
                print("new status: " + new_status)
                new_admin_notes = request.form.get('admin_notes_input')
                trainer_name_and_emails = request.form.getlist("update-trainer-slot[]")
                print(trainer_name_and_emails)
                date_format = '%Y-%m-%d %H:%M:%S'
                start_date = datetime.strptime(request.form.get("update-assignment-start-date"), date_format)
                end_date =  datetime.strptime(request.form.get("update-assignment-end-date"), date_format)
                formatted_start_date = request.form.get("update-assignment-formatted-start-date")
                formatted_end_time = request.form.get("update-assignment-formatted-end-time")
                event = Event.query.get(int(event_id))
                if event:
                    # Update the event status
                    print("updating event")
                    remove_asgs = Assignment.query \
                        .join(assignment_event_association)\
                        .join(Event)\
                        .join(assignment_trainer_association)\
                        .join(Trainer)\
                        .filter(Event.id == event.id)\
                        .options(joinedload(Assignment.trainer))\
                        .all()
                    for assignment in remove_asgs:
                        db.session.delete(assignment)
                        db.session.commit()
                    if (new_status != 'New' and new_status != 'Confirmed' and new_status !='Canceled'):
                        for trainer in trainer_name_and_emails:
                        # Split by spaces and parentheses
                            if (trainer):
                                split = re.split(r'\s\(|\)', trainer)
                                    # Remove empty strings from the result
                                result = list(filter(None, split))
                                if(len(result)<2):
                                    flash('Trainer ' + trainer + ' not found!', category='error')
                                    continue
                                trainer_name = result[0]
                                trainer_email = result[1]
                                print(trainer_name)
                                print(trainer_email)
                                cur_trainer = Trainer.query.filter(
                                    Trainer.nickname == trainer_name, Trainer.email == trainer_email).first()
                                if (not cur_trainer):
                                    continue
                                print(cur_trainer)
                                new_assignment = Assignment(start_date=start_date,
                                                                end_date=end_date,
                                                                formatted_start_date=formatted_start_date,
                                                                formatted_end_time=formatted_end_time,
                                                                trainer_role=cur_trainer.status)
                                new_assignment.event_request.append(event)
                                new_assignment.trainer.append(cur_trainer)
                                    # adding the note to the database
                                db.session.add(new_assignment)
                                db.session.commit()
                    event.status = new_status
                    event.admin_notes = new_admin_notes
                    db.session.commit()
                    flash('Event updated!', category='success')
                else:
                    flash('Event not found or could not be updated.', category='error')
            else:
                print("request.form.get(\"update_assignment\")is false")
        except Exception as e:
            print(f"An error occurred: {e}")
            db.session.rollback()  # Rollback the transaction in case of an error
    return redirect(url_for('views.home'))

@views.route('/get_assignment_trainers/<int:event_id>', methods=['GET'])
def get_trainers_count(event_id):
    trainers = Assignment.query \
                    .join(assignment_event_association)\
                    .join(Event)\
                    .join(assignment_trainer_association)\
                    .join(Trainer)\
                    .filter(Event.id == event_id)\
                    .options(joinedload(Assignment.trainer))\
                    .all()
    if trainers:
        current_trainers = []
        for trainer in trainers:
            current_trainers.append(trainer.name + " (" + trainer.email + ")")
    else:
        return jsonify({'error': 'Assignment not found'}), 404


@views.route('/delete-event', methods=['POST'])
def delete_event():
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
                'eventDisplay': 'background',
                'display': 'block',
                'displayEventEnd': True,
                'color': event_colors[(event.id - 1) % len(event_colors)][0],
                'eventTextColor': event_colors[(event.id - 1) % len(event_colors)][1],
                'extendedProps': {
                    'trainerTrue': False,
                    'formattedStartDate': slot.formatted_start_date,
                    'formattedEndTime': slot.formatted_end_time,
                    'eventId': event.id,
                    'numLearners': event.num_learners
                }
                # Add other attributes here as needed
            }
            event_list.append(time_dict)
        event_dict = {'events': event_list, 'id': event.id}
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
    from .models import User, Trainer, TrainerDate

    # Query the data from the database
    data = Trainer.query.all()

    # Convert the data to a list of dictionaries
    sources_list = []
    for trainer in data:
        event_list = []
        '''
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
        '''
        trainer_dict = {'events': event_list, 'id': trainer.id,
                        'full-name': trainer.name, 'name': trainer.nickname, 'email': trainer.email, 'status':trainer.status}
        sources_list.append(trainer_dict)
    # Convert the data to JSON
    json_data = jsonify(sources_list).get_data(as_text=True)

    # Save the JSON data to a file (optional)
    with open('trainer_mysql_data.json', 'w') as json_file:
        json_file.write(json_data)

    return json_data


@views.route('/trainer_availability', methods=['POST'])
def trainer_availability():
    print("Hello")
    if request.method == 'POST':
        try:
            json_data = request.get_json()[0]
            times = json_data.get('events')
            print("Posting:",json_data)
            for slot in times:
                name = slot['extendedProps']['trainerName']
                start_date = datetime.strptime(slot['startStr'], '%Y-%m-%dT%H:%M:%S%z')
                end_date = datetime.strptime(slot['endStr'], '%Y-%m-%dT%H:%M:%S%z')
                iso_formatted_start_date = slot['startStr']
                iso_formatted_end_date = slot['endStr']
                formatted_start_time = start_date.strftime('%A, %I:%M %p')
                formatted_end_time = end_date.strftime('%A, %I:%M %p')
                new_availability = TrainerDate(trainerName=name,start_date=start_date,
                                               end_date=end_date,iso_formatted_start_date=iso_formatted_start_date,
                                               iso_formatted_end_date=iso_formatted_end_date,formatted_start_time=formatted_start_time,
                                               formatted_end_time=formatted_end_time)
                db.session.add(new_availability)
            db.session.commit()
            print('Received JSON Data:', json_data)
            return jsonify(json_data)
        except Exception as e:
            print(str(e))
            return jsonify({'status': 'error', 'message': str(e)})
    else:
        print('request.method is not POST. It is: ', request.method)
'''
############
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


def create_event_dates(dates, starts, ends):
    event_dates = []
    for date, start_time, end_time in zip(dates, starts, ends):
        event_date = datetime.strptime(
            f"{date} {start_time}", "%Y-%m-%d %H:%M")
        end_date = datetime.strptime(f"{date} {end_time}", "%Y-%m-%d %H:%M")
        iso8601_start_date = event_date.isoformat()
        iso8601_end_date = end_date.isoformat()
        formatted_event_date = event_date.strftime('%m/%d/%Y %I:%M %p')
        formatted_end_time = end_date.strftime("%I:%M %p")
        new_event_date = EventDate(
            start_date=event_date, end_date=end_date, formatted_start_date=formatted_event_date, formatted_end_time=formatted_end_time, iso_formatted_start_date=iso8601_start_date, iso_formatted_end_date=iso8601_end_date)
        event_dates.append(new_event_date)
    return event_dates
