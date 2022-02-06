class Ngo { 
   final int id; 
   final String name; 
   final String location;
   final String area;
   final String phone;
   final String email;
   final String description; 
   final String latitude;
   final String longitude;   
   final String imageurl; 
   final String work;

   static final columns = ["id", "name","location","area","phone","email", "description", "latitude","longitude", "imageurl", "work"]; 
   Ngo(this.id, this.name, this.location, this.area, this.phone,this.email, this.description, this.latitude, this.longitude, this.imageurl,this.work); 
   
   factory Ngo.fromMap(Map<String, dynamic> data) {
      return Ngo( 
         data['id'], 
         data['name'], 
         data['location'],
         data['area'],
         data['phone'],
         data['email'],
         data['description'], 
         data['latitude'],
         data['longitude'],
         data['imageurl'], 
         data['work'],
      ); 
   } 
   Map<String, dynamic> toMap() => {
      "id": id, 
      "name": name, 
      "location": location,
      "area": area,
      "phone": phone,
      "email": email,
      "descrioption": description, 
      "latitude": latitude, 
      "longitude": longitude,
      "imageurl": imageurl,
      "work": work
   }; 
}