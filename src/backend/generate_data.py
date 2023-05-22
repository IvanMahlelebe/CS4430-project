import pandas as pd
import numpy as np
import random
from faker import Faker

fake = Faker()

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

# Generate random school data
school_names = [f"{fake.company().split(',', 1)[0]} {np.random.choice(['High School', 'Secondary', 'English Medium'], p=[0.7, 0.15, 0.15])}" for _ in range(SCHOOLS_NUM)]
school_data = {
    'schoolID': np.arange(1, SCHOOLS_NUM + 1),
    'regionID': np.random.choice(regionIDs, size=SCHOOLS_NUM, p=idweights),
    'schoolName': school_names,
}
school_df = pd.DataFrame(school_data)

valid_schoolID_regionID_combOs = school_df[['schoolID', 'regionID']]

# Generate random educator data
subject_list = np.random.choice(['Mathematics', 'Biology', 'Chemistry', 'Physics', 'English', 'History', 'Sesotho', 'Accounting', 'Geography'], size=TEACHERS_NUM)
qualification_list = np.random.choice(['Diploma', "Bachelor's degree", "Master's degree", 'PhD'], size=TEACHERS_NUM)
valid_schoolID_regionID_combOs = school_df[['schoolID', 'regionID']]

# Generate random educator data
subject_list = np.random.choice(['Mathematics', 'Biology', 'Chemistry', 'Physics', 'English', 'History', 'Sesotho', 'Accounting', 'Geography'], size=TEACHERS_NUM)
qualification_list = np.random.choice(['Diploma', "Bachelor's degree", "Master's degree", 'PhD'], size=TEACHERS_NUM)
educator_data = {
    'educatorID': np.arange(1, TEACHERS_NUM + 1),
    'regionID': [],
    'eName': [fake.name() for _ in range(TEACHERS_NUM)],
    'position': 'Teacher',
    'subject': subject_list,
    'qualification': qualification_list,
    'birthDate': fake.date_of_birth(minimum_age=23, maximum_age=65, tzinfo=None),
    'sex': np.random.choice(['Male', 'Female'], size=TEACHERS_NUM),
    'schoolID': [],
}

for _ in range(TEACHERS_NUM):
    row = valid_schoolID_regionID_combOs.sample()
    educator_data['schoolID'].append(row['schoolID'].values[0])
    educator_data['regionID'].append(row['regionID'].values[0])

educator_df = pd.DataFrame(educator_data)


# Generate random student data
student_data = {
    'studentID': np.arange(1, STUDENTS_NUM + 1),
    'studentName': [fake.first_name() for _ in range(STUDENTS_NUM)],
    'studentLastName': [fake.last_name() for _ in range(STUDENTS_NUM)],
    'regionID': np.random.choice(regionIDs, size=STUDENTS_NUM, p=idweights),
}
student_df = pd.DataFrame(student_data)

# Generate random school_educator data
school_educator_data = {
    'educatorID': [],
    'schoolID': [],
    'regionID': [],
    'transfer_date': [],
}

for _ in range(TEACHERS_NUM):
    row = educator_df.sample()
    educatorID = row['educatorID'].values[0]
    regionID = row['regionID'].values[0]
    schoolID = valid_schoolID_regionID_combOs[valid_schoolID_regionID_combOs['regionID'] == regionID]['schoolID'].sample().values[0]
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

for _ in range(STUDENTS_NUM):
    row = student_df.sample()
    studentID = row['studentID'].values[0]
    regionID = row['regionID'].values[0]
    schoolID = valid_schoolID_regionID_combOs[valid_schoolID_regionID_combOs['regionID'] == regionID]['schoolID'].sample().values[0]
    transferDate = fake.date_between(start_date='-5y', end_date='today')
    
    school_student_data['schoolID'].append(schoolID)
    school_student_data['regionID'].append(regionID)
    school_student_data['studentID'].append(studentID)
    school_student_data['transferDate'].append(transferDate)

school_student_df = pd.DataFrame(school_student_data)


# Generate random support data
intervention_list = np.random.choice([
    'Tutoring program',
    'Mentoring program',
    'Professional development',
    'Infrastructure improvement',
    'Curriculum enhancement',
], size=200)
outcome_list = np.random.choice([
    'Improved student performance',
    'Increased graduation rates',
    'Enhanced student engagement',
    'Reduced achievement gap',
], size=200)

support_data = {
    'supportID': np.arange(1, 201),
    'regionID': [],
    'type': intervention_list,
    'days_duration': np.random.randint(1, 101, size=200),
    'outcome': outcome_list,
    'schoolID': [],
}

for _ in range(200):
    regionID = valid_schoolID_regionID_combOs['regionID'].sample().values[0]
    schoolID = valid_schoolID_regionID_combOs[valid_schoolID_regionID_combOs['regionID'] == regionID]['schoolID'].sample().values[0]
    
    support_data['regionID'].append(regionID)
    support_data['schoolID'].append(schoolID)

support_df = pd.DataFrame(support_data)


# Generate random performance data
performance_valid_combinations = student_df[['studentID', 'regionID']]
# Generate random performance data
performance_data = {
    'performanceID': np.arange(1, STUDENTS_NUM + 1),
    'regionID': [],
    'grade': np.random.randint(1, 11, size=STUDENTS_NUM),
    'avg_score': np.random.normal(70, 10, size=STUDENTS_NUM),
    'studentID': [],
}

for _ in range(STUDENTS_NUM):
    regionID = performance_valid_combinations['regionID'].sample().values[0]
    studentID = performance_valid_combinations[performance_valid_combinations['regionID'] == regionID]['studentID'].sample().values[0]
    
    performance_data['regionID'].append(regionID)
    performance_data['studentID'].append(studentID)

performance_df = pd.DataFrame(performance_data)


# Generate random student_demography data
gender_list = np.random.choice(['Male', 'Female', 'Other'], size=100, p=[0.45, 0.45, 0.1])
student_demography_valid_combinations = student_df[['studentID', 'regionID']]
student_demography_data = {
    'demoID': np.arange(1, 101),
    'regionID': [],
    'studentID': [],
    'gender': gender_list,
    'race': np.random.choice(['Caucasian', 'African American', 'Asian', 'Hispanic', 'Other'], size=100),
    'disability': np.random.choice(['None', 'Physical', 'Intellectual', 'Sensory', 'Learning', 'Other'], size=100, p=[0.8, 0.06, 0.06, 0.06, 0.01, 0.01]),
    'socialStatus': np.random.choice(['Low', 'Middle', 'High'], size=100),
    'economicStatus': np.random.choice(['Low', 'Middle', 'High'], size=100),
}

for _ in range(100):
    regionID = student_demography_valid_combinations['regionID'].sample().values[0]
    studentID = student_demography_valid_combinations[student_demography_valid_combinations['regionID'] == regionID]['studentID'].sample().values[0]

    student_demography_data['regionID'].append(regionID)
    student_demography_data['studentID'].append(studentID)

student_demography_df = pd.DataFrame(student_demography_data)


# Save dataframes to CSV files
school_df.to_csv('school_data.csv', index=False)
educator_df.to_csv('educator_data.csv', index=False)
student_df.to_csv('student_data.csv', index=False)
school_educator_df.to_csv('school_educator_data.csv', index=False)
school_student_df.to_csv('school_student_data.csv', index=False)
support_df.to_csv('support_data.csv', index=False)
performance_df.to_csv('performance_data.csv', index=False)
student_demography_df.to_csv('student_demography_data.csv', index=False)
