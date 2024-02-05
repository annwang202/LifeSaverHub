from . import db
from flask_login import UserMixin
from sqlalchemy.sql import func


class User(db.Model, UserMixin):
    id = db.Column(db.Integer, primary_key=True)
    email = db.Column(db.String(150), unique=True)
    password = db.Column(db.String(150))    
    first_name = db.Column(db.String(150))

event_date_association = db.Table('event_date_association',
    db.Column('event_id', db.Integer, db.ForeignKey('event.id')),
    db.Column('event_date_id', db.Integer, db.ForeignKey('event_date.id'))
)
preferred_event_date_association = db.Table('preferred_event_date_association',
    db.Column('event_id', db.Integer, db.ForeignKey('event.id')),
    db.Column('event_date_id', db.Integer, db.ForeignKey('event_date.id'))
)


class EventDate(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    start_date = db.Column(db.DateTime(timezone=True))
    end_date = db.Column(db.DateTime(timezone=True))
    formatted_start_date = db.Column(db.String(100))
    formatted_end_time = db.Column(db.String(100))
    iso_formatted_start_date = db.Column(db.String(100))
    iso_formatted_end_date = db.Column(db.String(100))
    # Define a relationship with the Event model

class Event(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(50))
    email = db.Column(db.String(50))
    phone = db.Column(db.String(16))
    title = db.Column(db.String(50))
    training_types = db.Column(db.String(500))
    preferred_date = db.relationship('EventDate', secondary=preferred_event_date_association)
    backup_dates = db.relationship('EventDate', secondary=event_date_association)
    mission = db.Column(db.String(500))
    num_learners = db.Column(db.Integer)
    learners = db.Column(db.String(500))
    place = db.Column(db.String(500))
    chairs_tables = db.Column(db.String(300))
    cultural = db.Column(db.String(500))
    content_concerns = db.Column(db.String(500))
    music = db.Column(db.String(300))
    photos = db.Column(db.String(200))
    other_info = db.Column(db.String(1500))
    status = db.Column(db.String(100))
    admin_notes = db.Column(db.String(500))
    assignments = db.relationship('Assignment', backref = 'event', cascade = 'all, delete-orphan', lazy = 'dynamic')

class Trainer(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(50))
    nickname = db.Column(db.String(50))
    date_of_birth = db.Column(db.Date)
    pronouns = db.Column(db.String(50))
    race_ethnicity = db.Column(db.String(100))
    how_did_you_hear = db.Column(db.String(200))
    phone = db.Column(db.String(16))
    text_or_call = db.Column(db.String(16))
    email = db.Column(db.String(50))
    education = db.Column(db.String(100))
    lifesaver_skills = db.Column(db.String(500))
    relevant_exp = db.Column(db.String(500))
    heartsaver_interest = db.Column(db.String(4))
    gen_avail = db.Column(db.String(500))
    hrs_per_month = db.Column(db.Integer)
    languages = db.Column(db.String(50))
    availabilities = db.relationship('TrainerDate', backref = 'trainer', cascade = 'all, delete-orphan', lazy = 'dynamic')
    other_info = db.Column(db.String(1500))
    documents = db.Column(db.String(256))
    status = db.Column(db.String(100))
    assignments = db.relationship('Assignment', backref = 'trainer', cascade = 'all, delete-orphan', lazy = 'dynamic')
    admin_notes = db.Column(db.String(1500))

class TrainerDate(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    trainerName = db.Column(db.String(50))
    start_date = db.Column(db.DateTime(timezone=True))
    end_date = db.Column(db.DateTime(timezone=True))
    weekday = db.Column(db.String(20))
    formatted_start_time = db.Column(db.String(100))
    formatted_end_time = db.Column(db.String(100))
    iso_formatted_start_date = db.Column(db.String(100))
    iso_formatted_end_date = db.Column(db.String(100))
    trainer_id = db.Column(db.Integer, db.ForeignKey('trainer.id'),
            nullable=False)

class Assignment(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    start_date = db.Column(db.DateTime(timezone=True))
    end_date = db.Column(db.DateTime(timezone=True))
    formatted_start_date = db.Column(db.String(100))
    formatted_end_time = db.Column(db.String(100))
    event_id = db.Column(db.Integer, db.ForeignKey('event.id'),
        nullable=False)
    trainer_id = db.Column(db.Integer, db.ForeignKey('trainer.id'),
        nullable=False)
    trainer_status = db.Column(db.String(50))
    isLead = db.Column(db.Boolean,default=False)