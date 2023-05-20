import pandas as pd
import random
from faker import Faker

fake = Faker()

# Generate random school data
school_data = []
for i in range(20):
    school_data.append({
        'schoolID': i+1,
        'schoolName': fake.company(),
        'dID': random.randint(1, 10)
    })
school_df = pd.DataFrame(school_data)

# Generate random educator data
educator_data = []
for i in range(50):
    educator_data.append({
        'educatorID': i+1,
        'eName': fake.name(),
        'position': fake.job_title(),
        'subject': fake.word(),
        'qualification': fake.word(),
        'birthDate': fake.date_of_birth(minimum_age=25, maximum_age=60),
        'sex': random.choice(['Male', 'Female']),
        'schoolID': random.randint(1, 20)
    })
educator_df = pd.DataFrame(educator_data)

# Generate random student data
student_data = []
for i in range(100):
    student_data.append({
        'studentID': i+1,
        'studentName': fake.first_name(),
        'studentLastName': fake.last_name()
    })
student_df = pd.DataFrame(student_data)

# Generate random school_educator data
school_educator_data = []
for i in range(100):
    school_educator_data.append({
        'educatorID': random.randint(1, 50),
        'schoolID': random.randint(1, 20),
        'transfer_date': fake.date_between(start_date='-5y', end_date='today')
    })
school_educator_df = pd.DataFrame(school_educator_data)

# Generate random school_student data
school_student_data = []
for i in range(200):
    school_student_data.append({
        'schoolID': random.randint(1, 20),
        'studentID': random.randint(1, 100),
        'transferDate': fake.date_between(start_date='-5y', end_date='today')
    })
school_student_df = pd.DataFrame(school_student_data)

# Generate random support data
support_data = []
for i in range(50):
    support_data.append({
        'supportID': i+1,
        'type': fake.word(),
        'days_duration': random.randint(1, 30),
        'outcome': fake.sentence(),
        'schoolID': random.randint(1, 20)
    })
support_df = pd.DataFrame(support_data)

# Generate random performance data
performance_data = []
for i in range(100):
    performance_data.append({
        'performanceID': i+1,
        'grade': random.randint(1, 10),
        'avg_score': random.uniform(0, 100),
        'studentID': random.randint(1, 100)
    })
performance_df = pd.DataFrame(performance_data)

# Generate random student_demography data
student_demography_data = []
for i in range(100):
    student_demography_data.append({
        'demoID': i+1,
        'studentID': random.randint(1, 100),
        'gender': random.choice(['Male', 'Female']),
        'race': fake.word(),
        'disability': fake.word(),
        'socialStatus': fake.word(),
        'economicStatus': fake.word()
    })
student_demography_df = pd.DataFrame(student_demography_data)

# Save dataframes to Excel files
school_df.to_excel('school_data.xlsx', index=False)
educator_df.to_excel('educator_data.xlsx', index=False)
student_df.to_excel('student_data.xlsx', index=False)
school_educator_df.to_excel('school_educator_data.xlsx', index=False)
school_student_df.to_excel('school_student_data.xlsx', index=False)
support_df.to_excel('support_data.xlsx', index=False)
performance_df.to_excel('performance_data.xlsx', index=False)
student_demography_df.to_excel('student_demography_data.xlsx', index=False)
