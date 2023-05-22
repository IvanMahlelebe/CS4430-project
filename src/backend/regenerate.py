import pandas as pd
import numpy as np
import random
from faker import Faker

fake = Faker()

# Read the CSV file into a DataFrame
educator_df = pd.read_csv('./educator_data.csv')
student_df = pd.read_csv('./student_data.csv')
school_df = pd.read_csv('./school_data.csv')

SCHOOLS_NUM = 326
STUDENTS_NUM = 106023
TEACHERS_NUM = 4430

regionIDs = [1, 2, 3, 4]
idweights = []
for _ in range(4):
    random_number = random.randint(1, 10)
    idweights.append(random_number)

idweights_sum = sum(idweights)
idweights = [weight / idweights_sum for weight in idweights]

valid_schoolID_regionID_combOs = school_df[['schoolID', 'regionID']]

# Generate random school_educator data
school_educator_data = {
    'educatorID': [],
    'schoolID': [],
    'regionID': [],
    'transfer_date': [],
}

existing_combinations = set()  # Track existing combinations of (schoolID, regionID) pairs

for _ in range(TEACHERS_NUM):
    row = educator_df.sample()
    educatorID = row['educatorID'].values[0]
    regionID = row['regionID'].values[0]

    # Generate a unique (schoolID, regionID) pair
    while True:
        schoolID = valid_schoolID_regionID_combOs[valid_schoolID_regionID_combOs['regionID'] == regionID]['schoolID'].sample().values[0]
        combination = (schoolID, regionID)
        if combination not in existing_combinations:
            existing_combinations.add(combination)
            break

    transfer_date = fake.date_between(start_date='-5y', end_date='today')

    school_educator_data['educatorID'].append(educatorID)
    school_educator_data['schoolID'].append(schoolID)
    school_educator_data['regionID'].append(regionID)
    school_educator_data['transfer_date'].append(transfer_date)

school_educator_df = pd.DataFrame(school_educator_data)


# Generate random school_student data
school_student_data = {
    'schoolID': [],
    'regionID': [],
    'studentID': [],
    'transferDate': [],
}

existing_combinations = set()  # Track existing combinations of (schoolID, regionID) pairs

for _ in range(STUDENTS_NUM):
    row = student_df.sample()
    studentID = row['studentID'].values[0]
    regionID = row['regionID'].values[0]

    # Generate a unique (schoolID, regionID) pair
    while True:
        schoolID = valid_schoolID_regionID_combOs[valid_schoolID_regionID_combOs['regionID'] == regionID]['schoolID'].sample().values[0]
        combination = (schoolID, regionID)
        if combination not in existing_combinations:
            existing_combinations.add(combination)
            break

    transferDate = fake.date_between(start_date='-5y', end_date='today')

    school_student_data['schoolID'].append(schoolID)
    school_student_data['regionID'].append(regionID)
    school_student_data['studentID'].append(studentID)
    school_student_data['transferDate'].append(transferDate)

school_student_df = pd.DataFrame(school_student_data)

school_educator_df.to_csv('school_educator_data.csv', index=False)
school_student_df.to_csv('school_student_data.csv', index=False)
