package IAS;

// This file would normally belong in src/java , because we have access
// to the source code for it, and we want to compile it and 
// install it.  The reason it's here in THIS case is to test the ability
// for other applications to link against it.

public class SampleLibrary {
	public void SayHello(){
		System.out.println("Hello, from sample library!");
	}
}
