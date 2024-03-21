"""empty message

Revision ID: 92993f6a554f
Revises: 12ebc8a1afb5
Create Date: 2024-03-21 10:29:50.178767

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = '92993f6a554f'
down_revision = '12ebc8a1afb5'
branch_labels = None
depends_on = None


def upgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    with op.batch_alter_table('resource', schema=None) as batch_op:
        batch_op.add_column(sa.Column('resource_id', sa.Integer(), nullable=True))
        batch_op.create_foreign_key(None, 'resource', ['resource_id'], ['id'])
    # ### end Alembic commands ###


def downgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    with op.batch_alter_table('trainer', schema=None) as batch_op:
        batch_op.alter_column('id',
               existing_type=sa.INTEGER(),
               server_default=sa.Identity(always=False, start=1, increment=1, minvalue=1, maxvalue=2147483647, cycle=False, cache=1),
               existing_nullable=False,
               autoincrement=True)

    with op.batch_alter_table('event', schema=None) as batch_op:
        batch_op.alter_column('id',
               existing_type=sa.INTEGER(),
               server_default=sa.Identity(always=False, start=1, increment=1, minvalue=1, maxvalue=2147483647, cycle=False, cache=1),
               existing_nullable=False,
               autoincrement=True)

    with op.batch_alter_table('assignment', schema=None) as batch_op:
        batch_op.drop_constraint(None, type_='foreignkey')
        batch_op.alter_column('end_date',
               existing_type=sa.DateTime(timezone=True),
               type_=sa.VARCHAR(length=100),
               existing_nullable=True)
        batch_op.alter_column('start_date',
               existing_type=sa.DateTime(timezone=True),
               type_=sa.VARCHAR(length=100),
               existing_nullable=True)
        batch_op.alter_column('id',
               existing_type=sa.INTEGER(),
               server_default=sa.Identity(always=False, start=1, increment=1, minvalue=1, maxvalue=2147483647, cycle=False, cache=1),
               existing_nullable=False,
               autoincrement=True)
        batch_op.drop_column('resource_id')

    # ### end Alembic commands ###