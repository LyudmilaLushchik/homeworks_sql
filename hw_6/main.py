import configparser
import sqlalchemy
from sqlalchemy.orm import sessionmaker
from models import create_tables, drop_tables, Publisher, Book, Shop, Stock, Sale
import json


# Запрос выборки магазинов, продающих целевого издателя.
def shops_selling_publisher(session, publ_id=None, publ_name=None):
    shop_q = session.query(Shop).join(Stock.shop_r).join(Stock.book_r).join(Book.publisher_r)

    if publ_id is not None:
        publ_q = session.query(Publisher).filter(Publisher.id == publ_id).subquery()
    elif publ_name is not None:
        publ_q = session.query(Publisher).filter(Publisher.name == publ_name).subquery()

    all_q = shop_q.join(publ_q, Book.id_publisher == publ_q.c.id)
    for shop in all_q:
        print(shop)


if __name__ == '__main__':
    config = configparser.ConfigParser()
    config.read("settings.ini")
    user = config["db_info"]["user"]
    password = config["db_info"]["password"]
    name_db = config["db_info"]["name_db"]

    DSN = f"postgresql://{user}:{password}@localhost:5432/{name_db}"
    engine = sqlalchemy.create_engine(DSN)

    create_tables(engine)

    Session = sessionmaker(bind=engine)
    session = Session()

    with open('tests_data.json', 'r') as fd:
        data = json.load(fd)

    for record in data:
        model = {
            'publisher': Publisher,
            'shop': Shop,
            'book': Book,
            'stock': Stock,
            'sale': Sale,
        }[record.get('model')]
        session.add(model(id=record.get('pk'), **record.get('fields')))
    session.commit()

    publisher = input('Введите id или имя издателя: ')
    if publisher.strip().isnumeric():
        shops_selling_publisher(session, publ_id=publisher.strip())
    else:
        shops_selling_publisher(session, publ_name=publisher.strip())

    session.close()

    drop_tables(engine)