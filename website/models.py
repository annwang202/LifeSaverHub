from . import db
from flask_login import UserMixin
from sqlalchemy.sql import func

class Note(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    data = db.Column(db.String(10000))
    date = db.Column(db.DateTime(timezone=True), default=func.now())
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'))


class User(db.Model, UserMixin):
    id = db.Column(db.Integer, primary_key=True)
    email = db.Column(db.String(150), unique=True)
    password = db.Column(db.String(150))    
    first_name = db.Column(db.String(150))
    notes = db.relationship('Note')

event_date_association = db.Table('event_date_association',
    db.Column('event_id', db.Integer, db.ForeignKey('event.id')),
    db.Column('event_date_id', db.Integer, db.ForeignKey('event_date.id'))
)

trainer_date_association = db.Table('trainer_date_association',
    db.Column('trainer_id', db.Integer, db.ForeignKey('trainer.id')),
    db.Column('trainer_date_id', db.Integer, db.ForeignKey('trainer_date.id'))
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
    events = db.relationship('Event', secondary=event_date_association, back_populates='dates',order_by='EventDate.start_date')

class TrainerDate(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    start_date = db.Column(db.DateTime(timezone=True))
    end_date = db.Column(db.DateTime(timezone=True))
    formatted_start_date = db.Column(db.String(100))
    formatted_end_time = db.Column(db.String(100))
    iso_formatted_start_date = db.Column(db.String(100))
    iso_formatted_end_date = db.Column(db.String(100))
    # Define a relationship with the Event model
    trainers = db.relationship('Trainer', secondary=trainer_date_association, back_populates='dates',order_by='TrainerDate.start_date')


class Event(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    dates = db.relationship('EventDate', secondary=event_date_association, back_populates='events')
    title = db.Column(db.String(150))
    description = db.Column(db.String(1500))

class Trainer(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(150))
    dates = db.relationship('TrainerDate', secondary=trainer_date_association, back_populates='trainers')
    other_info = db.Column(db.String(1500))