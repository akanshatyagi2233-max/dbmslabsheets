from flask import Flask, render_template, request, redirect, url_for
from pymongo import MongoClient

app = Flask(__name__)

# MongoDB Connection Setup (Q1 & Q5)
client = MongoClient("mongodb://localhost:27017/")
db = client['CollegeDB']
collection = db['students']

print("Connected successfully to MongoDB CollegeDB!")

@app.route('/')
def home():
    return render_template('index.html')

# Q3, Q6: Add Student
@app.route('/add', methods=['GET', 'POST'])
def add_student():
    if request.method == 'POST':
        student_data = {
            "student_id": request.form['student_id'],
            "name": request.form['name'],
            "age": int(request.form['age']),
            "gender": request.form['gender'],
            "department": request.form['department'],
            "marks": float(request.form['marks'])
        }
        collection.insert_one(student_data)
        return redirect(url_for('view_students'))
    return render_template('add_student.html')

# Q7: View All Students
@app.route('/students')
def view_students():
    students = list(collection.find())
    return render_template('view_students.html', students=students)

# Q8: Search Student
@app.route('/search', methods=['GET', 'POST'])
def search_student():
    student = None
    searched = False
    if request.method == 'POST':
        s_id = request.form['student_id']
        student = collection.find_one({"student_id": s_id})
        searched = True
    return render_template('search_student.html', student=student, searched=searched)

# Q9: Update Student
@app.route('/update', methods=['GET', 'POST'])
def update_student():
    message = ""
    if request.method == 'POST':
        s_id = request.form['student_id']
        updated_fields = {
            "name": request.form['name'],
            "age": int(request.form['age']),
            "department": request.form['department'],
            "marks": float(request.form['marks'])
        }
        result = collection.update_one({"student_id": s_id}, {"$set": updated_fields})
        if result.matched_count > 0:
            message = "Student record updated successfully!"
        else:
            message = "Student ID not found."
    return render_template('update_student.html', message=message)

# Q10: Delete Student
@app.route('/delete', methods=['GET', 'POST'])
def delete_student():
    message = ""
    if request.method == 'POST':
        s_id = request.form['student_id']
        result = collection.delete_one({"student_id": s_id})
        if result.deleted_count > 0:
            message = "Student deleted successfully!"
        else:
            message = "Student ID not found."
    return render_template('delete_student.html', message=message)

# Q11: MongoDB Filtering Operations
@app.route('/filters')
def filter_students():
    dept = request.args.get('dept')
    
    # Queries:
    dept_students = list(collection.find({"department": dept})) if dept else []
    above_75 = list(collection.find({"marks": {"$gt": 75}}))
    between_50_80 = list(collection.find({"marks": {"$gte": 50, "$lte": 80}}))
    older_than_20 = list(collection.find({"age": {"$gt": 20}}))

    return render_template('filter_students.html', 
                           dept_students=dept_students,
                           above_75=above_75,
                           between_50_80=between_50_80,
                           older_than_20=older_than_20)

if __name__ == '__main__':
    app.run(debug=True)
