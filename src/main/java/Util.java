import java.sql.*;
import java.util.*;

public class Util {
    public static Connection Connect(){
        Connection c = null;
        try {
            Class.forName("org.postgresql.Driver");
            c= DriverManager.getConnection("jdbc:postgresql://postgresql-supercat.alwaysdata.net:5432/supercat_db",
                    "supercat","Junjie2022");
          //  c = DriverManager.getConnection("")
        }catch (Exception e){
            e.printStackTrace();
            System.err.println(e.getClass().getName()+":"+e.getMessage());
            System.exit(0);
        }
        System.out.println("Opened database successfully");
        return c;
    }
    public static void select(){
        Connection c = Util.Connect();
        Statement stmt = null;
        List<HashMap<String, Object>> list = new ArrayList<>();
        try{
            stmt = c.createStatement();
            String sql = "SELECT * FROM public.ucs";
            ResultSet rs = stmt.executeQuery(sql);
            ResultSetMetaData metaData = rs.getMetaData();  //obtenir tous les noms de columns
            int columnCount = metaData.getColumnCount(); // le nombre de columns
            while(rs.next()) {
                HashMap<String, Object> map = new HashMap<>();
                for (int i = 1; i <= columnCount; i++) {
                    String name = metaData.getColumnName(i);
                    Object object = rs.getObject(i);
                    map.put(name, object);
                    // System.out.println(object);
                }

                list.add(map);
                //   Set<String> keys =
                for (HashMap<String, Object> hashMap : list) {
                    hashMap.forEach((key, value) -> {
                        System.out.print(" key: " + key + " value: " + value);
                    });
                    System.out.println();
                    //   System.out.println(hashMap);
                }
                System.out.println(" un autre version");
                for (HashMap<String, Object> hashMap : list) {
                    for (HashMap.Entry<String, Object> entry : hashMap.entrySet()) {
                        System.out.println(" key :" + entry.getKey() + " value: " + entry.getValue());
                    }
                    System.out.println();
                    //
                    //     rs.close();
                    //     stmt.close();
                    c.close();
                }
            }
        }catch (SQLException throwables){
            throwables.printStackTrace();
        }
    }
    public static void main(String[] args) {
       // Connect();
        select();

    }
}
