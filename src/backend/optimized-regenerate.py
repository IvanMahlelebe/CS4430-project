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
idweights = random.choices(range(1, 11), k=4)
idweights = [weight / sum(idweights) for weight in idweights]

# Generate random school_educator data
educator_samples = educator_df.sample(n=TEACHERS_NUM, replace=True)
educator_samples.reset_index(drop=True, inplace=True)

school_educator_data = {
  'educatorID': educator_samples['educatorID'],
  'schoolID': [],
  'regionID': [],
  'transfer_date': [],
}

existing_combinations = set()

for _ in range(TEACHERS_NUM):
  while True:
    regionID = np.random.choice(regionIDs)
    schoolID = np.random.choice(school_df[school_df['regionID'] == regionID]['schoolID'])
    educatorID = np.random.choice(educator_samples['educatorID'])
    combination = (schoolID, educatorID, regionID)
    if combination not in existing_combinations:
      existing_combinations.add(combination)
      break

  transfer_date = fake.date_between(start_date='-5y', end_date='today')

  school_educator_data['schoolID'].append(schoolID)
  school_educator_data['regionID'].append(regionID)
  school_educator_data['transfer_date'].append(transfer_date)

school_educator_df = pd.DataFrame(school_educator_data)

# Generate random school_student data
student_samples = student_df.sample(n=STUDENTS_NUM, replace=True)
student_samples.reset_index(drop=True, inplace=True)

school_student_data = {
  'schoolID': [],
  'regionID': [],
  'studentID': [],
  'transferDate': [],
}

existing_combinations = set()

for _ in range(STUDENTS_NUM):
  while True:
    regionID = np.random.choice(regionIDs)
    schoolID = np.random.choice(school_df[school_df['regionID'] == regionID]['schoolID'])
    studentID = np.random.choice(student_samples['studentID'])
    combination = (schoolID, regionID, studentID)
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
