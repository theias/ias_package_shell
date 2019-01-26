package IAS;

import IAS.SampleLibrary;
import IAS.SomeLocalDependency;

public class SampleApplication {
	public static void main(String[] args) {
		System.out.println("Hello, World!");

		SampleLibrary sample_object = new SampleLibrary();
		sample_object.SayHello();

		SomeLocalDependency local_dependency = new SomeLocalDependency();
		local_dependency.SayHello();
		
		System.out.println("So long, and thanks for all the fish!");
	}
}

