from flask import Blueprint, render_template, request, flash, jsonify, redirect, url_for
from flask_login import login_required, current_user
from .models import Event, EventDate, Trainer, TrainerDate, Assignment, Resource
from . import db
import json
from datetime import datetime, time, timedelta
from sqlalchemy import asc, extract, Time, func, Date
from werkzeug.utils import secure_filename
import re
from sqlalchemy.orm import joinedload
import traceback
import pytz


views = Blueprint('views', __name__)
event_colors = {"New": "#ff8503", "Confirmed": "#7f04d1", "Tentative": "#039e72", "Scheduled": "#03329e",
                "Happened": "grey", "Canceled": "grey"}
tz = pytz.timezone('America/New_York')


@views.route('/', methods=['GET', 'POST'])
@login_required
def home():
    eventModel = Event.query.all()
    events = (
    Event.query
    .join(Event.dates)  # Assuming 'dates' is the relationship attribute in Event
    .order_by(EventDate.start_date)
    .all()
)
    assignments = Assignment.query.all()
    trainers = Trainer.query.all()

    # for loading scheduled assignments column
    assignments_by_event = []
    for event in events:
        print(event.dates)
        event_assignments = event.assignments.all()
        if (not event_assignments):
            continue
        info = {"event": event, "trainers": [], "assignments": []}
        for assignment in event_assignments:
            trainer = Trainer.query.filter(
                Trainer.id == assignment.trainer_id).first()
            role = ""
            if (assignment.isLead):
                role = "Team Lead"
            else:
                role = "Trainer"
            info["trainers"].append({"trainer": trainer, "role": role})
            info["assignments"].append(assignment)
        assignments_by_event.append(info)
    '''
    assignments = Assignment.query.options(
        joinedload(Assignment.event_request)).all()
    for trainer in trainers:
        if trainer.gen_avail:
            trainer.gen_avail.sort(key=lambda date: date.start_date)
    '''
    trainers_data = [{'id': trainer.id, 'name': trainer.name,
                      'gen_avail': trainer.gen_avail} for trainer in trainers]
    return render_template("home.html", user=current_user, events=events, trainers=trainers, assignments=assignments, assignments_by_event=assignments_by_event, trainers_data=trainers_data, event_colors=event_colors)

@views.route('/resources', methods=['GET', 'POST'])
@login_required
def resources():
    resources = Resource.query.order_by(Resource.name).all()
    resource_data = []
    for resource in resources:
        resource_data.append(resource.name)
    return render_template("resources.html", user=current_user, resources=resources, resource_data=resource_data)


@views.route('/resourceSearch', methods=['GET', 'POST'])
@login_required
def resourcesearch():
    resources = Resource.query.order_by(Resource.name).all()
    resource_data = []
    for resource in resources:
        resource_data.append(resource.name)
    return render_template("resourceSearch.html", user=current_user, resources=resources, resource_data=resource_data)

@views.route('/advancedsearch', methods=['GET', 'POST'])
@login_required
def advancedsearch():
    trainers = Trainer.query.order_by(Trainer.name).all()
    new_count = Trainer.query.filter_by(status="New").count()
    lead_count = Trainer.query.filter_by(status="Team Lead").count()
    basic_count = Trainer.query.filter_by(status="Basic Trainer").count()
    inactive_count = Trainer.query.filter_by(status="Inactive").count()
    suspended_count = Trainer.query.filter_by(status="Suspended").count()
    trainers_data = []
    for trainer in trainers:
        trainers_data.append(trainer.name)
    return render_template("advancedSearch.html", user=current_user, trainers=trainers, trainers_data=trainers_data,new_count=new_count,
                           lead_count=lead_count,basic_count=basic_count,inactive_count=inactive_count,suspended_count=suspended_count)


@views.route('/availabilitySummary/<string:event_date>/<string:eventStart>/<string:eventEnd>/<int:showAll>/<int:addCheckboxes>', methods=['GET', 'POST'])
@login_required
def availabilitySummary(event_date, showAll, addCheckboxes, eventStart, eventEnd):
    date = datetime.strptime(event_date, '%Y-%m-%d').date()
    weekday = date.strftime('%A')

    allTrainers = Trainer.query.order_by(Trainer.name).all()
    # get all trainers with availability on this day
    day = TrainerDate.query.filter(
        TrainerDate.weekday == weekday.capitalize()).all()
    thisDay = toDict(day)

    day_start = thisDay[0]["start_date"]
    day_start_time = day_start.replace(hour=0, minute=0, second=0)
    day_end_time = day_start_time + timedelta(days=1)

    print(date)
    alreadyAssigned = Assignment.query.filter(func.cast(Assignment.start_date, Date) == func.cast(date, Date)
                                              ).all()
    assigned = {}
    for assignment in alreadyAssigned:
        events = Event.query.filter(Event.id == assignment.event_id).all()
        for i in events:
            key = str(assignment.trainer_id)
            if (key not in assigned):
                assigned[str(assignment.trainer_id)] = []
            assigned[str(assignment.trainer_id)].append(i.title)


    if (eventStart != "no" and eventEnd != "no"):
        eventStart = datetime.strptime(eventStart, "%H:%M")
        eventEnd = datetime.strptime(eventEnd, "%H:%M")
        eventStart = day_start.replace(
            hour=eventStart.hour, minute=eventStart.minute)
        eventEnd = day_start.replace(
            hour=eventEnd.hour, minute=eventEnd.minute)

    trainerData = []
    unavailables = []
    if showAll:
        for trainer in allTrainers:
            trainer_dict = {
                "id": trainer.id, "nickname": trainer.nickname, "status": trainer.status}
            trainerData.append(trainer_dict)
    else:
        # trainers availability this day
        trainer_ids = set([date["trainer_id"] for date in thisDay])
        for trainer in allTrainers:
            trainer_dict = {
                "id": trainer.id, "nickname": trainer.nickname, "status": trainer.status}
            if trainer.id in trainer_ids:
                trainerData.append(trainer_dict)
            else:
                unavailables.append(trainer_dict)

    return render_template("availabilitySummary.html", availability=thisDay, trainerData=trainerData, unavailables=unavailables, day_start=day_start_time.isoformat(), day_end=day_end_time.isoformat(), eventStart=eventStart, eventEnd=eventEnd, addCheckboxes=addCheckboxes, alreadyAssigned=assigned)


def toDict(query):
    dayList = []
    for date in query:
        dict = {"id": date.id, "trainerName": date.trainerName, "start_date": date.start_date, "end_date": date.end_date, "weekday": date.weekday,
                "formatted_start_time": date.formatted_start_time, "formatted_end_time": date.formatted_end_time,
                "iso_formatted_start_date": date.iso_formatted_start_date, "iso_formatted_end_date": date.iso_formatted_end_date,
                "trainer_id": date.trainer_id}
        dayList.append(dict)
    return dayList


@views.route('/alreadyAssigned/<string:event_date>/', methods=['GET', 'POST'])
@login_required
def alreadyAssigned(event_date):
    date = datetime.strptime(event_date, '%Y-%m-%d').date()
    weekday = date.strftime('%A')
    alreadyAssigned = Assignment.query.filter(func.cast(Assignment.start_date, Date) == func.cast(date, Date)
                                              ).all()
    assigned = {}
    for assignment in alreadyAssigned:
        events = Event.query.filter(Event.id == assignment.event_id).all()
        for i in events:
            key = str(assignment.trainer_id)
            if (key not in assigned):
                assigned[str(assignment.trainer_id)] = []
            assigned[str(assignment.trainer_id)].append(i.title)
    return jsonify(assigned)


@views.route('/trainee', methods=['GET', 'POST'])
@login_required
def trainee():
    return render_template("trainee.html", user=current_user)


@views.route('/trainer', methods=['GET', 'POST'])
@login_required
def trainer():
    return render_template("trainer.html", user=current_user)


@views.route('/trainer_info', methods=['GET', 'POST'])
@login_required
def trainer_info():
    trainers = Trainer.query.order_by(Trainer.name).all()
    new_count = Trainer.query.filter_by(status="New").count()
    lead_count = Trainer.query.filter_by(status="Team Lead").count()
    basic_count = Trainer.query.filter_by(status="Basic Trainer").count()
    inactive_count = Trainer.query.filter_by(status="Inactive").count()
    suspended_count = Trainer.query.filter_by(status="Suspended").count()
    trainers_data = []
    for trainer in trainers:
        trainers_data.append(trainer.name)
    return render_template("trainer_info.html", user=current_user, trainers=trainers, trainers_data=trainers_data,new_count=new_count,
                           lead_count=lead_count,basic_count=basic_count,inactive_count=inactive_count,suspended_count=suspended_count)


@views.route('/submit-event', methods=['GET', 'POST'])
@login_required
def submit_event():
    if request.method == 'POST':
        try:
            if request.form.get("event_form"):  # get event form submission
                name = request.form["event_name"]
                email = request.form["event_email"]
                phone = request.form["event_phone"]
                title = request.form["event_title"]
                if (not title or title == ""):
                    title = name
                training_types = request.form.getlist('training_type[]')
                training_types_string = ', '.join(training_types)
                
                eventDatesField = request.form.get('eventDates')
                eventDatesData = json.loads(eventDatesField)

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
                                mission=mission, num_learners=num_learners, learners=learners, place=place, chairs_tables=chairs_tables, cultural=cultural,
                                content_concerns=content_concerns, music=music, photos=photos, other_info=other_info, status=status)
                if (len(eventDatesField) != 0):
                    eventDates = create_event_dates(eventDatesData)
                    for eventDate in eventDates:
                        new_event.dates.append(eventDate)
                db.session.add(new_event)  # adding the event to the database
                db.session.commit()
                flash('Event added to list!', category='success')
        except Exception as e:
            print(f"An error occurred: {e}")
            traceback.print_exc()
            db.session.rollback()

    return redirect(url_for('views.trainee'))


@views.route('/submit-trainer', methods=['GET', 'POST'])
@login_required
def submit_trainer():
    if request.method == 'POST':
        # get training availability form submission
        try:
            if request.form.get("trainer_form"):
                print("trainer form gotten")
                trainer_name = request.form["trainer_name"]
                trainer_nickname = request.form["trainer_nickname"]
                if (not trainer_nickname or trainer_nickname == ""):
                    trainer_nickname = trainer_name
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
                print("form data gotten")
                new_trainer = Trainer(name=trainer_name, nickname=trainer_nickname, date_of_birth=bd_date, pronouns=trainer_pronouns,
                                      race_ethnicity=trainer_race, how_did_you_hear=how_did_you_hear,
                                      phone=trainer_phone, text_or_call=text_or_call, email=trainer_email, education=trainer_education,
                                      lifesaver_skills=ls_skills_background_string, relevant_exp=relevant_experience,
                                      heartsaver_interest=heartsaver_instructor_interest, hrs_per_month=preferred_hrs_per_month,
                                      languages=trainer_languages, other_info=other_info, status="New")
                print(new_trainer)
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
                db.session.add(new_trainer)
                print("trainer added")
                db.session.commit()
                flash('Trainer added to list!', category='success')

                # collect trainerData
                event_source_data = request.form.get('eventSource')
                times = json.loads(event_source_data).get('events', [])
                print("Posting:", times)
                for slot in times:
                    name = slot.get('extendedProps').get('trainerName')
                    start_date = datetime.strptime(
                        slot.get('startStr'), '%Y-%m-%dT%H:%M:%S%z')
                    end_date = datetime.strptime(
                        slot.get('endStr'), '%Y-%m-%dT%H:%M:%S%z')
                    weekday = start_date.strftime('%A')
                    iso_formatted_start_date = slot.get('startStr')
                    iso_formatted_end_date = slot.get('endStr')
                    formatted_start_time = start_date.strftime('%I:%M %p')
                    formatted_end_time = end_date.strftime('%I:%M %p')
                    new_availability = TrainerDate(trainerName=name, start_date=start_date,
                                                   end_date=end_date, weekday=weekday, iso_formatted_start_date=iso_formatted_start_date,
                                                   iso_formatted_end_date=iso_formatted_end_date, formatted_start_time=formatted_start_time,
                                                   formatted_end_time=formatted_end_time, trainer_id=new_trainer.id)
                    db.session.add(new_availability)
                db.session.commit()
        except Exception as e:
            print(f"An error occurred: {e}")
            traceback.print_exc()
            db.session.rollback()  # Rollback the transaction in case of an error
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
                event_id = request.form["event-id"]
                print(event_id)
                start_date = request.form.get("start-date")
                print(start_date[:-6])
                request_date = datetime.strptime(
                    start_date[:-6],  "%Y-%m-%dT%H:%M:%S")
                start_time = datetime.strptime(
                    request.form["start_time"], "%H:%M")
                print("checkpoint 4")
                end_time = datetime.strptime(request.form["end_time"], "%H:%M")
                start_date = request_date.replace(
                    hour=start_time.hour, minute=start_time.minute)
                end_date = request_date.replace(
                    hour=end_time.hour, minute=end_time.minute)
                print("checkpoint 5")
                formatted_start_date = start_date.strftime('%m/%d/%Y %I:%M %p')
                formatted_end_time = end_date.strftime("%I:%M %p")
                trainer_name_and_emails = request.form.getlist(
                    "trainer-slot[]")
                team_lead = request.form["leader-slot"]
                event = Event.query.get(event_id)
                lead_assignment = create_assignment(trainer=team_lead, event=event, start_date=start_date, end_date=end_date,
                                                    formatted_start_date=formatted_start_date,
                                                    formatted_end_time=formatted_end_time, isLead=True)
                if (lead_assignment):
                    db.session.add(lead_assignment)
                    print(lead_assignment)
                for trainer in trainer_name_and_emails:
                    new_assignment = create_assignment(trainer=trainer, event=event, start_date=start_date, end_date=end_date,
                                                       formatted_start_date=formatted_start_date,
                                                       formatted_end_time=formatted_end_time, isLead=False)
                    if (new_assignment):
                        db.session.add(new_assignment)
                        print(new_assignment)
                db.session.commit()
        except Exception as e:
            print(f"An error occurred: {e}")
            traceback.print_exc()
            db.session.rollback()  # Rollback the transaction in case of an error
    return redirect(url_for('views.home'))


def create_assignment(trainer, event, start_date, end_date, formatted_start_date, formatted_end_time, isLead):
    if (trainer):
        split = re.search(r'(.+?) \(ID: (\d+)\)', trainer)
        if (not split or len(split.groups()) < 2):
            flash('Trainer ' + trainer + ' not found!', category='error')
            return None
        trainer_name = split.group(1)
        trainer_id = split.group(2)
        print(trainer_name)
        print(trainer_id)
        cur_trainer = Trainer.query.filter(
            Trainer.nickname == trainer_name, Trainer.id == trainer_id).first()
        if (not cur_trainer):
            return None
        print(cur_trainer)
        # only change event status to Tentative if there is a trainer to assign to it
        event.status = "Tentative"
        new_assignment = Assignment(start_date=start_date,
                                    end_date=end_date,
                                    formatted_start_date=formatted_start_date,
                                    formatted_end_time=formatted_end_time,
                                    event_id=event.id, trainer_id=cur_trainer.id,
                                    trainer_status=cur_trainer.status, isLead=isLead)
        return new_assignment


@views.route('/update-event', methods=['GET', 'POST'])
@login_required
def update_event():
    if request.method == 'POST':
        if request.form.get("update_form"):  # get event form submission
            update_id = request.form.get('update_id')
            new_status = request.form.get('status')
            new_admin_notes = request.form.get('admin_event_notes')
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
            print(new_status)
            new_admin_notes = request.form.get('admin_trainer_notes')
            cpr_aed = request.form.get(
            'CPR_AED') is not None
            stb = request.form.get('STB') is not None
            narcan = request.form.get('Narcan') is not None
            aha_hs = request.form.get('AHA_HS') is not None
            aha_bls = request.form.get('AHA_BLS') is not None
            trainer = Trainer.query.get(update_id)
            if trainer:
                # Update the event status
                trainer.status = new_status
                trainer.admin_notes = new_admin_notes
                trainer.CPR_AED = cpr_aed
                trainer.STB = stb
                trainer.Narcan = narcan
                trainer.AHA_HS = aha_hs
                trainer.AHA_BLS = aha_bls
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
                event_id = request.form.get('event-id')
                print("event_id: " + event_id)
                new_status = request.form.get('update_assignment_status')
                print("new status: " + new_status)
                new_admin_notes = request.form.get('admin_notes_input')
                team_lead = request.form["leader-slot"]
                trainer_name_and_emails = request.form.getlist(
                    "trainer-slot[]")
                print(trainer_name_and_emails)
                date_format = '%Y-%m-%d %H:%M:%S'
                request_start = request.form.get("start-date")
                request_end = request.form.get("end-date")
                print(request_start)
                start_date = datetime.strptime(request_start, date_format)
                end_date = datetime.strptime(request_end, date_format)
                print(start_date)
                formatted_start_date = request.form.get(
                    "formatted-start-date")
                formatted_end_time = request.form.get(
                    "formatted-end-time")
                event = Event.query.get(int(event_id))
                hasTrainer = False
                if event:
                    # Update the event status
                    print("updating event")
                    # delete old assignments to create new assignmen
                    remove_asgs = Assignment.query \
                        .filter(Assignment.event_id == event.id)\
                        .all()
                    for assignment in remove_asgs:
                        db.session.delete(assignment)
                        db.session.commit()
                    if (new_status != 'New' and new_status != 'Confirmed' and new_status != 'Canceled'):
                        # if event has no trainer assigned, change event status to "New" or "Confirmed"
                        lead_assignment = create_assignment(trainer=team_lead, event=event, start_date=start_date, end_date=end_date,
                                                            formatted_start_date=formatted_start_date,
                                                            formatted_end_time=formatted_end_time, isLead=True)
                        if (lead_assignment):
                            db.session.add(lead_assignment)
                            print(lead_assignment)
                            hasTrainer = True
                        for trainer in trainer_name_and_emails:
                            new_assignment = create_assignment(trainer=trainer, event=event, start_date=start_date, end_date=end_date,
                                                               formatted_start_date=formatted_start_date,
                                                               formatted_end_time=formatted_end_time, isLead=False)
                            if (new_assignment):
                                db.session.add(new_assignment)
                                print(new_assignment)
                                hasTrainer = True
                    if (not hasTrainer and new_status != "New"):
                        event.status = "Confirmed"
                    else:
                        event.status = new_status
                    event.admin_notes = new_admin_notes
                    db.session.commit()
                    flash('Event updated!', category='success')
                else:
                    flash('Event not found or could not be updated.',
                          category='error')
            else:
                print("request.form.get(\"update_assignment\")is false")
        except Exception as e:
            print(f"An error occurred: {e}")
            traceback.print_exc()
            db.session.rollback()  # Rollback the transaction in case of an error
    return redirect(url_for('views.home'))


@views.route('/get_assignment_trainers/<int:event_id>', methods=['GET'])
def get_trainers_count(event_id):
    trainers = Assignment.query \
        .filter(Assignment.event_id == event_id)\
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
    from .models import Event

    # Query the data from the database
    data = Event.query.all()

    # Convert the data to a list of dictionaries
    sources_list = []
    for event in data:
        event_list = []
        for slot in (event.dates):
            time_dict = {
                'id': slot.id,
                'title': event.title,
                'allDay': slot.allDay,
                'start': slot.iso_formatted_start_date,
                'end': slot.iso_formatted_end_date,
                'eventDisplay': 'background',
                'display': 'block',
                'displayEventEnd': True,
                'color': event_colors[event.status],
                'eventTextColor': event_colors[event.status],
                'extendedProps': {
                    'trainerTrue': False,
                    'formattedStartDate': slot.formatted_start_date,
                    'formattedEndTime': slot.formatted_end_time,
                    'eventId': event.id,
                    'numLearners': event.num_learners,
                    'timeOfDay':slot.timeOfDay
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


@views.route('/assignmentdata')
def assignment_mysql_to_json():
    from .models import Event, Assignment

    events = Event.query.all()
    assignment_by_event = (
        db.session.query(Assignment.event_id)
        .distinct()
        .all()
    )
    assignments = Assignment.query.all()

    # Convert the data to a list of dictionaries
    sources_list = []
    for event_id in assignment_by_event:
        event_list = []
        assignment = (
            db.session.query(Assignment)
            .filter(Assignment.event_id == event_id.event_id)
            .first()
        )
        event = Event.query.get(assignment.event_id)
        print("start_date type:" + str(type(assignment.start_date)))
        time_dict = {
            'id': event.id,
            'title': event.title,
            'start': datetime.strptime(assignment.start_date, "%Y-%m-%d %H:%M:%S").isoformat(),
            'end': datetime.strptime(assignment.end_date, "%Y-%m-%d %H:%M:%S").isoformat(),
            'displayEventEnd': True,
            'color': event_colors[event.status],
            'eventTextColor': event_colors[event.status],
            'extendedProps': {
                'trainerTrue': True,
                'formattedStartDate': assignment.formatted_start_date,
                'formattedEndTime': assignment.formatted_end_time,
                'eventId': event.id,
                'numLearners': event.num_learners
            }
        }
        event_list.append(time_dict)
        event_dict = {'events': event_list, 'id': event.id}
        sources_list.append(event_dict)

    # Convert the data to JSON
    json_data = jsonify(sources_list).get_data(as_text=True)

    # Save the JSON data to a file (optional)
    with open('assignment_mysql_data.json', 'w') as json_file:
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
                        'full-name': trainer.name, 'name': trainer.nickname, 'email': trainer.email, 'status': trainer.status}
        sources_list.append(trainer_dict)
    # Convert the data to JSON
    json_data = jsonify(sources_list).get_data(as_text=True)

    # Save the JSON data to a file (optional)
    with open('trainer_mysql_data.json', 'w') as json_file:
        json_file.write(json_data)

    return json_data


@views.route('/trainer_availability/<string:weekday>/<string:start>/<string:end>', methods=['GET'])
def trainer_availability(weekday, start, end):
    print("Hello")
    starttime = datetime.strptime(start, "%H:%M").time()
    endtime = datetime.strptime(end, "%H:%M").time()
    print(starttime)
    print(endtime)
    query = TrainerDate.query.filter(
        db.func.lower(TrainerDate.weekday) == weekday).all()

    print(query)
    if query:
        result = []
        for trainer_date in query:
            if (trainer_date.start_date.time() <= starttime and ((trainer_date.end_date.time() >= endtime) or trainer_date.end_date.time() == time(0, 0))):
                result.append({'trainer_id': trainer_date.trainer_id, 'name': trainer_date.trainerName, 'weekday': trainer_date.weekday,
                               'start': trainer_date.start_date, 'end': trainer_date.end_date})
        return jsonify(result)
    else:
        return jsonify({'error': 'Query failed'}), 404


@views.route('/trainer_availability/<string:weekday>', methods=['GET'])
def trainer_availability_weekday(weekday):
    query = TrainerDate.query.filter(
        db.func.lower(TrainerDate.weekday) == weekday).all()

    print(query)
    if query:
        result = []
        for trainer_date in query:
            result.append({'trainer_id': trainer_date.trainer_id, 'name': trainer_date.trainerName, 'weekday': trainer_date.weekday,
                           'start': trainer_date.start_date, 'end': trainer_date.end_date})
        return jsonify(result)
    else:
        return jsonify({'error': 'Query failed'}), 404


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


def create_event_dates(eventDates):
    ret = []
    print(eventDates)
    for slot in eventDates:
        iso8601_start_date = slot["start_date"]
        iso8601_end_date = slot["end_date"]
        allDay = slot["allDay"]
        timeOfDay = slot["timeOfDay"]
        event_date = datetime.fromisoformat(iso8601_start_date)
        end_date = datetime.fromisoformat(iso8601_end_date)
        if allDay:
            if timeOfDay == "Morning":
                event_date = event_date.replace(hour=8, minute=0, second=0)
                end_date = end_date.replace(hour=11, minute=0, second=0)
            elif timeOfDay == "Afternoon":
                event_date = event_date.replace(hour=13, minute=0, second=0)
                end_date = end_date.replace(hour=16, minute=0, second=0)
            elif timeOfDay == "Evening":
                event_date = event_date.replace(hour=16, minute=0, second=0)
                end_date = end_date.replace(hour=19, minute=0, second=0)
        formatted_event_date = event_date.strftime('%m/%d/%Y %I:%M %p')
        formatted_end_time = end_date.strftime("%I:%M %p")
        new_event_date = EventDate(
           start_date=event_date, end_date=end_date, formatted_start_date=formatted_event_date, 
           formatted_end_time=formatted_end_time, iso_formatted_start_date=iso8601_start_date, 
           iso_formatted_end_date=iso8601_end_date, allDay=allDay, timeOfDay=timeOfDay)
        ret.append(new_event_date)
    return ret
